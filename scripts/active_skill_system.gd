extends Control

class_name ActiveSkillSystem

var active_skills: Array = []
var skill_cooldowns: Dictionary = {}
var player_faction: int = 0
var mana: int = 100
var max_mana: int = 100
var mana_regen: float = 5.0

signal skill_used(skill: Dictionary)
signal skill_cooldown_started(skill_name: String, duration: float)
signal skill_cooldown_ended(skill_name: String)

@onready var skill_buttons = $VBoxContainer/SkillButtons
@onready var mana_label = $ManaBar/ManaLabel
@onready var mana_progress = $ManaBar/ManaProgress

const TACTICAL_INSIGHT_SKILL = "tactical_insight"
const CHARISMA_SKILL = "charisma"

func _ready() -> void:
    setup_skills()
    setup_cooldown_timers()
    setup_mana_system()

func setup_skills() -> void:
    var tactical_skill = create_skill_data(
        "Tactical Insight",
        "Reveals hidden enemy units within range",
        "active",
        5.0,
        8.0,
        0.0
    )
    
    var charisma_skill = create_skill_data(
        "Charisma",
        "Boosts nearby ally combat power temporarily",
        "active",
        10.0,
        15.0,
        60.0
    )
    
    active_skills = [tactical_skill, charisma_skill]
    skill_cooldowns = {
        "Tactical Insight": 0.0,
        "Charisma": 0.0
    }
    
    update_skill_ui()

func create_skill_data(name: String, description: String, type: String, 
                          cooldown: float, duration: float, cost: float) -> Dictionary:
    return {
        "name": name,
        "description": description,
        "type": type,
        "cooldown": cooldown,
        "duration": duration,
        "cost": cost,
        "is_active": false,
        "remaining_cooldown": 0.0
    }

func _process(delta: float) -> void:
    update_cooldowns(delta)
    regen_mana(delta)
    update_skill_ui()

func update_cooldowns(delta: float) -> void:
    for skill_name in skill_cooldowns:
        if skill_cooldowns[skill_name] > 0:
            skill_cooldowns[skill_name] -= delta
            
            if skill_cooldowns[skill_name] <= 0:
                skill_cooldowns[skill_name] = 0.0
                skill_cooldown_ended.emit(skill_name)

func regen_mana(delta: float) -> void:
    mana = min(mana + int(mana_regen * delta), max_mana)
    
    if mana_label:
        mana_label.text = "Mana: %d/%d" % [mana, max_mana]
    if mana_progress:
        mana_progress.value = float(mana)

func use_skill(skill_name: String) -> void:
    var skill = get_skill_by_name(skill_name)
    if not skill:
        return
    
    if skill["remaining_cooldown"] > 0 or mana < skill["cost"]:
        return
    
    mana -= int(skill["cost"])
    
    match skill_name:
        "Tactical Insight":
            use_tactical_insight()
        "Charisma":
            use_charisma()
    
    skill_cooldowns[skill_name] = skill["cooldown"]
    skill["is_active"] = true
    skill_used.emit(skill)
    
    GameManager.log_event("skill_used", {
        "skill": skill_name,
        "cost": skill["cost"],
        "cooldown": skill["cooldown"]
    })

func use_tactical_insight() -> void:
    GameManager.game_state["scout_accuracy_bonus"] = 0.2
    
    var enemies = GameManager.game_state.get("armies", [])
    for army in enemies:
        if army.get("faction_id", 0) != player_faction:
            reveal_enemy_army(army)
    
    GameManager.log_event("tactical_insight_used", {
        "revealed_armies": get_enemy_count()
    })

func use_charisma() -> void:
    GameManager.game_state["charisma_bonus"] = 0.15
    
    var player_armies = GameManager.game_state.get("armies", [])
    for army in player_armies:
        if army.get("faction_id", 0) == player_faction:
            apply_charisma_boost(army)
    
    GameManager.log_event("charisma_used", {
        "boosted_armies": get_player_army_count()
    })

func reveal_enemy_army(army_data: Dictionary) -> void:
    var position = army_data.get("position", Vector2.ZERO)
    var accuracy = GameManager.get_information_accuracy()
    
    if GameManager.game_state.has("revealed_enemies"):
        GameManager.game_state["revealed_enemies"].append({
            "army_id": army_data.get("army_id", 0),
            "position": position,
            "accuracy": accuracy,
            "timestamp": Time.get_unix_time_from_system()
        })
    else:
        GameManager.game_state["revealed_enemies"] = [{
            "army_id": army_data.get("army_id", 0),
            "position": position,
            "accuracy": accuracy,
            "timestamp": Time.get_unix_time_from_system()
        }]

func apply_charisma_boost(army_data: Dictionary) -> void:
    if army_data.has("morale"):
        var current_morale = army_data.get("morale", 100)
        army_data["morale"] = min(current_morale + 15, 100)

func get_skill_by_name(skill_name: String) -> Dictionary:
    for skill in active_skills:
        if skill["name"] == skill_name:
            return skill
    return {}

func get_enemy_count() -> int:
    if not GameManager.game_state.has("revealed_enemies"):
        return 0
    
    var count = 0
    for enemy in GameManager.game_state["revealed_enemies"]:
        if Time.get_unix_time_from_system() - enemy.get("timestamp", 0) < 60:
            count += 1
    
    return count

func get_player_army_count() -> int:
    var count = 0
    var armies = GameManager.game_state.get("armies", [])
    for army in armies:
        if army.get("faction_id", 0) == player_faction:
            count += 1
    return count

func update_skill_ui() -> void:
    if not skill_buttons:
        return
    
    for child in skill_buttons.get_children():
        child.queue_free()
    
    for skill in active_skills:
        var skill_button = create_skill_button(skill)
        skill_buttons.add_child(skill_button)

func create_skill_button(skill: Dictionary) -> Button:
    var button = Button.new()
    button.text = "%s (Cost: %d)" % [skill["name"], int(skill["cost"])]
    button.custom_minimum_size = Vector2(280, 40)
    
    if skill["remaining_cooldown"] > 0:
        button.disabled = true
        button.text = "%s (%.1fs)" % skill["name"]
        button.modulate = Color.GRAY
    elif mana < skill["cost"]:
        button.disabled = true
        button.modulate = Color.RED
    else:
        button.disabled = false
        button.modulate = Color.WHITE
    
    button.pressed.connect(func(): use_skill(skill["name"]))
    return button

func get_all_skills() -> Array:
    return active_skills

func get_available_mana() -> int:
    return mana

func is_on_cooldown(skill_name: String) -> bool:
    return skill_cooldowns.get(skill_name, 0.0) > 0

func get_cooldown_remaining(skill_name: String) -> float:
    return skill_cooldowns.get(skill_name, 0.0)

func apply_mana_cost(cost: int) -> void:
    mana -= cost
    mana = max(0, mana)

func add_mana(amount: int) -> void:
    mana += amount
    mana = min(mana, max_mana)
