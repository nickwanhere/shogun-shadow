extends Node

const AttackVisualizer = preload("res://scripts/attack_visualizer.gd")
const BlockVisualizer = preload("res://scripts/block_visualizer.gd")
const DamageIndicator = preload("res://scripts/damage_indicator.gd")
const FogOfWarVisualizer = preload("res://scripts/fog_of_war_visualizer.gd")
const Scout = preload("res://scripts/enhanced_scout.gd")
const Meeting = preload("res://scripts/meeting.gd")

@onready var world = $World
@onready var tile_map = $World/TileMap
@onready var perch_interface = $GameUI/PerchInterface
@onready var skill_panel = $GameUI/SkillPanel
@onready var information_panel = $GameUI/InformationPanel
@onready var health_label = $GameUI/HealthBar/HealthLabel
@onready var health_bar = $GameUI/HealthBar/HealthProgressBar
@onready var stamina_label = $GameUI/StaminaBar/StaminaLabel
@onready var stamina_bar = $GameUI/StaminaBar/StaminaProgressBar

var player_character: CharacterBody2D
var player_combat_script
var attack_visualizer
var block_visualizer
var fog_visualizer: FogOfWarVisualizer
var scout_deployment_ui
var information_display_ui
var active_skill_system: ActiveSkillSystem
var army_command_system: ArmyCommandSystem
var enemy_ai: EnemyAI
var meeting_system: Meeting
var armies: Array = []
var scouts: Array = []
var gold: int = 1000

func _ready() -> void:
    setup_player_character()
    setup_tile_map()
    setup_fog_system()
    setup_scout_system()
    setup_information_system()
    setup_meeting_system()
    setup_skill_system()
    setup_army_system()
    setup_enemy_ai()
    setup_visualizers()
    setup_connections()
    GameManager.initialize_game_state()
    GameManager.reveal_fog_of_war(GameManager.game_state["player_position"], 5)
    update_ui()

func setup_player_character() -> void:
    player_character = $World/PlayerCharacter
    player_character.position = GameManager.game_state["player_position"]
    
    var sprite = Sprite2D.new()
    sprite.texture = create_placeholder_texture(Color.BLUE)
    sprite.scale = Vector2(0.9, 0.9)
    player_character.add_child(sprite)
    
    var collision = CollisionShape2D.new()
    var shape = RectangleShape2D.new()
    shape.size = Vector2(28, 28)
    collision.shape = shape
    player_character.add_child(collision)

func setup_tile_map() -> void:
    tile_map.set("format", 1)
    tile_map.tile_set = create_tile_set()

    for x in range(50):
        for y in range(50):
            tile_map.set_cell(0, Vector2i(x, y), 0, Vector2i(0, 0))

func create_tile_set() -> TileSet:
    var tile_set = TileSet.new()

    var texture = create_placeholder_texture(Color(0.5, 0.8, 0.5), Vector2i(32, 32))

    var atlas_source = TileSetAtlasSource.new()
    atlas_source.texture = texture
    atlas_source.texture_region_size = Vector2i(32, 32)

    tile_set.add_source(atlas_source, 0)

    return tile_set

func create_placeholder_texture(color: Color, size: Vector2i = Vector2i(32, 32)) -> ImageTexture:
    var image = Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
    image.fill(color)
    var texture = ImageTexture.new()
    texture.set_image(image)
    return texture

func setup_fog_system() -> void:
    fog_visualizer = FogOfWarVisualizer.new()
    fog_visualizer.connect("fog_updated", _on_fog_updated)
    fog_visualizer.connect("tile_revealed", _on_tile_revealed)
    world.add_child(fog_visualizer)

func setup_scout_system() -> void:
    scout_deployment_ui = ScoutDeploymentUI.new()
    scout_deployment_ui.connect("scout_deployed", _on_scout_deployed)
    scout_deployment_ui.connect("scout_recalled", _on_scout_recalled)
    $GameUI.add_child(scout_deployment_ui)

func setup_information_system() -> void:
    information_display_ui = InformationDisplay.new()
    $GameUI.add_child(information_display_ui)

func setup_meeting_system() -> void:
    meeting_system = Meeting.new()
    meeting_system.connect("meeting_decision_selected", _on_meeting_decision_selected)
    $GameUI.add_child(meeting_system)

func setup_army_system() -> void:
    army_command_system = ArmyCommandSystem.new()
    army_command_system.connect("army_moved", _on_army_moved)
    army_command_system.connect("attack_order_executed", _on_attack_order_executed)
    world.add_child(army_command_system)
    
    armies = army_command_system.armies
    GameManager.game_state["armies"] = armies

func setup_enemy_ai() -> void:
    enemy_ai = EnemyAI.new()
    enemy_ai.command_system = army_command_system
    enemy_ai.connect("ai_decision_made", _on_ai_decision_made)
    add_child(enemy_ai)

func setup_skill_system() -> void:
    active_skill_system = ActiveSkillSystem.new()
    active_skill_system.connect("skill_used", _on_skill_used)
    active_skill_system.connect("skill_cooldown_started", _on_skill_cooldown_started)
    active_skill_system.connect("skill_cooldown_ended", _on_skill_cooldown_ended)
    $GameUI.add_child(active_skill_system)
    
    GameManager.game_state["revealed_enemies"] = []
    GameManager.game_state["mana"] = active_skill_system.get_available_mana()
    GameManager.game_state["max_mana"] = active_skill_system.get_available_mana()

func setup_visualizers() -> void:
    attack_visualizer = AttackVisualizer.new()
    attack_visualizer.is_player = true
    world.add_child(attack_visualizer)
    
    block_visualizer = BlockVisualizer.new()
    block_visualizer.is_player = true
    world.add_child(block_visualizer)

func setup_connections() -> void:
    InputManager.move_player.connect(_on_move_player)
    InputManager.attack.connect(_on_attack)
    InputManager.block.connect(_on_block)
    InputManager.call_meeting.connect(_on_call_meeting)
    InputManager.deploy_scout.connect(_on_deploy_scout)
    InputManager.toggle_scout_ui.connect(_on_toggle_scout_ui)
    InputManager.toggle_info_ui.connect(_on_toggle_info_ui)
    GameManager.game_state_changed.connect(_on_game_state_changed)

func _process(delta: float) -> void:
    var fps = Engine.get_frames_per_second()
    if fps < 30:
        GameManager.log_event("performance", {"fps": fps, "warning": true})

func _on_move_player(direction: String) -> void:
    var movement = Vector2.ZERO
    match direction:
        "north":
            movement = Vector2(0, -1)
            GameManager.game_state["player_attack_direction"] = 0
        "south":
            movement = Vector2(0, 1)
            GameManager.game_state["player_attack_direction"] = 2
        "east":
            movement = Vector2(1, 0)
            GameManager.game_state["player_attack_direction"] = 1
        "west":
            movement = Vector2(-1, 0)
            GameManager.game_state["player_attack_direction"] = 3
    
    var new_pos = player_character.position + movement * 32
    new_pos = Vector2(clamp(new_pos.x, 0, 49 * 32), clamp(new_pos.y, 0, 49 * 32))
    
    player_character.position = new_pos
    var grid_pos = new_pos / 32
    GameManager.update_player_position(grid_pos)
    
    if fog_visualizer:
        fog_visualizer.reveal_area(grid_pos, 5)
    
    GameManager.log_event("move", {"direction": direction, "position": new_pos})

func _on_attack() -> void:
    var direction = GameManager.game_state["player_attack_direction"]
    attack_visualizer.start_attack(direction, "slash")
    GameManager.log_event("attack", {
        "direction": direction,
        "position": player_character.position
    })

func _on_block(should_block: bool) -> void:
    GameManager.game_state["player_is_blocking"] = should_block
    if should_block:
        player_character.modulate = Color.GRAY
        block_visualizer.start_block(GameManager.game_state["player_attack_direction"])
    else:
        player_character.modulate = Color.WHITE
        block_visualizer.stop_block()
    GameManager.log_event("block", {"blocking": should_block})

func _on_call_meeting() -> void:
    if meeting_system:
        meeting_system.start_meeting(meeting_system.get_default_meeting_data())
        GameManager.log_event("meeting", {"type": "call_meeting"})

func _on_scout_deployed(scout: Scout) -> void:
    scouts.append(scout)
    world.add_child(scout)
    GameManager.game_state["scouts"] = scouts

func _on_scout_recalled(scout: Scout) -> void:
    if scout in scouts:
        scouts.erase(scout)
    GameManager.game_state["scouts"] = scouts

func _on_fog_updated(visible_tiles: Array) -> void:
    pass

func _on_tile_revealed(position: Vector2i) -> void:
    pass

func _on_deploy_scout(mouse_position: Vector2) -> void:
    var tile_pos = (world.global_position + mouse_position) / 32
    tile_pos = Vector2i(int(clamp(tile_pos.x, 0, 49)), int(clamp(tile_pos.y, 0, 49)))
    
    if scout_deployment_ui:
        var scout = Scout.new()
        scout.scout_id = scouts.size()
        scout.faction_id = 0
        scouts.append(scout)
        world.add_child(scout)
        
        scout.deploy_at(tile_pos)
        scout.connect("information_retrieved", _on_scout_information_retrieved)
        
        GameManager.game_state["scouts"] = scouts
        GameManager.log_event("scout_manual_deploy", {
            "scout_id": scout.scout_id,
            "position": tile_pos
        })

func _on_scout_information_retrieved(info: Dictionary) -> void:
    if information_display_ui:
        information_display_ui.add_information(info)

func _on_toggle_scout_ui() -> void:
    if scout_deployment_ui:
        scout_deployment_ui.visible = not scout_deployment_ui.visible

func _on_toggle_info_ui() -> void:
    if information_display_ui:
        information_display_ui.visible = not information_display_ui.visible

func _on_army_moved(army: Army) -> void:
    pass

func _on_attack_order_executed(attacker: Army, defender: Army, result: Dictionary) -> void:
    if information_display_ui:
        var attack_info = {
            "info_type": "enemy_strength",
            "data": {
                "attack_result": result.type,
                "attacker_power": int(result.attacker_power),
                "defender_power": int(result.defender_power),
                "ratio": result.ratio
            },
            "accuracy": 0.9,
            "source": "battle_report"
        }
        information_display_ui.add_information(attack_info)
    
    GameManager.log_event("battle_result", {
        "attacker": attacker.army_id,
        "defender": defender.army_id,
        "result": result.type
    })

func _on_meeting_decision_selected(option_index: int) -> void:
    GameManager.log_event("meeting_decision", {"option_index": option_index})

func _on_ai_decision_made(decision: Dictionary) -> void:
    if information_display_ui:
        var ai_info = {
            "info_type": "enemy_strength",
            "data": {
                "decision_type": decision.type,
                "enemy_id": decision.army_id,
                "target": decision.target,
                "confidence": decision.confidence
            },
            "accuracy": 0.7,
            "source": "scout_intercept"
        }
        information_display_ui.add_information(ai_info)

func _on_skill_used(skill: Dictionary) -> void:
    GameManager.log_event("active_skill_used", {
        "skill": skill.get("name", "unknown"),
        "cost": skill.get("cost", 0)
    })

func _on_skill_cooldown_started(skill_name: String, duration: float) -> void:
    GameManager.log_event("skill_cooldown_started", {
        "skill": skill_name,
        "duration": duration
    })

func _on_skill_cooldown_ended(skill_name: String) -> void:
    GameManager.log_event("skill_cooldown_ended", {
        "skill": skill_name
    })

func _on_game_state_changed() -> void:
    update_ui()

func update_ui() -> void:
    if health_label:
        health_label.text = "Health: %d/%d" % [GameManager.game_state["player_health"], GameManager.game_state["player_max_health"]]
    if health_bar:
        health_bar.value = float(GameManager.game_state["player_health"])
    if stamina_label:
        stamina_label.text = "Stamina: %d/%d" % [GameManager.game_state["player_stamina"], GameManager.game_state["player_max_stamina"]]
    if stamina_bar:
        stamina_bar.value = float(GameManager.game_state["player_stamina"])
