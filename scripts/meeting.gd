extends Control

signal meeting_decision_selected(option_index: int)

var meeting_active: bool = false
var is_active: bool = false

var meeting_timer: float = 30.0
var current_meeting_data: Dictionary = {}
var game_speed_before_meeting: float = 1.0

@onready var time_label = $TimeLabel
@onready var situation_panel = $SituationPanel
@onready var options_panel = $OptionsPanel
@onready var info_panel = $InfoPanel

func _ready() -> void:
    visible = false

func start_meeting(meeting_data: Dictionary) -> void:
    current_meeting_data = meeting_data
    meeting_active = true
    is_active = true
    meeting_timer = 30.0
    visible = true
    
    game_speed_before_meeting = Engine.time_scale
    Engine.time_scale = 0.5
    
    update_meeting_ui()
    set_process(true)

func _process(delta: float) -> void:
    if meeting_active:
        meeting_timer -= delta
        update_timer()
        
        if meeting_timer <= 0:
            meeting_timer_expired()

func update_timer() -> void:
    if time_label:
        time_label.text = "Time Remaining: %d seconds" % int(max(0, meeting_timer))

func update_meeting_ui() -> void:
    update_situation_panel()
    update_info_panel()
    update_options_panel()

func update_situation_panel() -> void:
    var situation_text = "Current Battlefield Situation:\n\n"
    
    situation_text += "Player Position: %s\n" % str(GameManager.game_state["player_position"])
    situation_text += "Player Health: %d/%d\n" % [GameManager.game_state["player_health"], GameManager.game_state["player_max_health"]]
    situation_text += "Player Stamina: %d/%d\n" % [GameManager.game_state["player_stamina"], GameManager.game_state["player_max_stamina"]]
    
    var armies = GameManager.game_state["armies"]
    situation_text += "\nArmies: %d\n" % armies.size()
    
    if situation_panel:
        situation_panel.text = situation_text

func update_info_panel() -> void:
    var info_text = "Available Information:\n\n"
    
    var information = GameManager.game_state["information_sources"]
    if information.size() > 0:
        for info in information:
            info_text += "Source: %s\n" % info.get("source", "unknown")
            info_text += "Accuracy: %.0f%%\n" % (info.get("accuracy", 0.0) * 100)
            info_text += "\n"
    else:
        info_text += "No information available.\n"
    
    if info_panel:
        info_panel.text = info_text

func update_options_panel() -> void:
    var options = current_meeting_data.get("options", [])
    
    if options_panel:
        options_panel.text = "Decision Options:\n\n"
        for i in range(options.size()):
            var option = options[i]
            options_panel.text += "%d. %s\n" % [i + 1, option.get("name", "Option")]
            options_panel.text += "   %s\n" % option.get("description", "")
            options_panel.text += "\n"

func select_option(option_index: int) -> void:
    if not meeting_active:
        return
    
    var options = current_meeting_data.get("options", [])
    if option_index < 0 or option_index >= options.size():
        return
    
    current_meeting_data["selected_option"] = option_index
    apply_decision_consequences(options[option_index])
    end_meeting()
    meeting_decision_selected.emit(option_index)

func apply_decision_consequences(option: Dictionary) -> void:
    var consequences = option.get("consequences", {})
    
    if consequences.has("attack_power"):
        GameManager.game_state["attack_power_bonus"] = consequences["attack_power"]
    
    if consequences.has("defense"):
        GameManager.game_state["defense_bonus"] = consequences["defense"]
    
    if consequences.has("morale"):
        apply_morale_change(consequences["morale"])
    
    if consequences.has("army_speed"):
        GameManager.game_state["army_speed_bonus"] = consequences["army_speed"]
    
    if consequences.has("scout_accuracy"):
        GameManager.game_state["scout_accuracy_bonus"] = consequences["scout_accuracy"]
    
    GameManager.log_event("decision_consequences", {
        "option": option.get("name", "Unknown"),
        "consequences": consequences
    })

func apply_morale_change(morale_change: float) -> void:
    var armies = GameManager.game_state["armies"]
    var player_faction = 0
    
    for army in armies:
        if army.faction_id == player_faction and not army.is_queued_for_deletion():
            army.morale = clamp(army.morale + int(morale_change * 100), 0, 100)
    
    GameManager.log_event("morale_change", {
        "change": morale_change,
        "affected_armies": get_player_army_count()
    })

func get_player_army_count() -> int:
    var count = 0
    var armies = GameManager.game_state["armies"]
    var player_faction = 0
    
    for army in armies:
        if army.faction_id == player_faction and not army.is_queued_for_deletion():
            count += 1
    
    return count

func end_meeting() -> void:
    var selected_option_index = current_meeting_data.get("selected_option", -1)
    
    if selected_option_index >= 0:
        var options = current_meeting_data.get("options", [])
        if selected_option_index < options.size():
            apply_decision_consequences(options[selected_option_index])
    
    meeting_active = false
    is_active = false
    visible = false
    Engine.time_scale = game_speed_before_meeting
    set_process(false)
    
    GameManager.game_state["current_meeting"] = null
    GameManager.log_event("meeting_end", {})

func meeting_timer_expired() -> void:
    var options = current_meeting_data.get("options", [])
    if options.size() > 0:
        var random_index = randi() % options.size()
        select_option(random_index)
    else:
        end_meeting()

func get_default_meeting_data() -> Dictionary:
    return {
        "type": "tactical",
        "options": [
            {
                "name": "Charge Enemy",
                "description": "Aggressive attack strategy",
                "consequences": {
                    "attack_power": 0.2,
                    "defense": -0.15,
                    "morale": -0.1
                }
            },
            {
                "name": "Defend Position",
                "description": "Defensive strategy",
                "consequences": {
                    "attack_power": -0.1,
                    "defense": 0.25,
                    "morale": 0.0
                }
            },
            {
                "name": "Retreat to Castle",
                "description": "Strategic retreat",
                "consequences": {
                    "attack_power": 0.0,
                    "defense": 0.0,
                    "morale": -0.2
                }
            }
        ]
    }
