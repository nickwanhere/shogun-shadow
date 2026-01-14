extends Node2D

class_name ArmyCommandSystem

var armies: Array = []
var selected_army: Army = null
var player_faction: int = 0
var enemy_faction: int = 1

signal army_selected(army: Army)
signal army_moved(army: Army)
signal attack_order_executed(attacker: Army, defender: Army, result: Dictionary)

@onready var tile_map = get_parent().get_node("TileMap")

func _ready() -> void:
    setup_armies()
    setup_connections()

func setup_armies() -> void:
    create_player_armies()
    create_enemy_armies()
   GameManager.game_state["armies"] = armies

func create_player_armies() -> void:
    for i in range(2):
        var army = create_army(player_faction, i)
        army.faction_id = player_faction
        armies.append(army)
        add_child(army)

func create_enemy_armies() -> void:
    for i in range(3):
        var army = create_army(enemy_faction, i + 2)
        army.faction_id = enemy_faction
        armies.append(army)
        add_child(army)

func create_army(faction_id: int, army_id: int) -> Army:
    var army = preload("res://scripts/army.gd").new()
    army.army_id = army_id
    army.faction_id = faction_id
    army.unit_count = 50 + randi() % 50
    army.unit_type = get_random_unit_type()
    army.morale = 80 + randi() % 20
    army.supplies = 50 + randi() % 50
    army.is_selected = false
    
    var x_pos = 10 + (army_id * 10) % 40
    var y_pos = 10 + (army_id * 15) % 40
    army.position = Vector2(x_pos * 32, y_pos * 32)
    
    army.connect("army_selected", _on_army_selected_signal)
    
    return army

func get_random_unit_type() -> String:
    var types = ["infantry", "cavalry", "archers"]
    return types[randi() % types.size()]

func setup_connections() -> void:
    for army in armies:
        if not army.is_connected("army_selected"):
            army.connect("army_selected", _on_army_selected_signal)

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed:
        if event.button_index == MOUSE_BUTTON_LEFT:
            handle_left_click()
        elif event.button_index == MOUSE_BUTTON_RIGHT:
            handle_right_click()

func handle_left_click() -> void:
    var mouse_pos = get_viewport().get_mouse_position()
    var tile_pos = get_tile_at_position(mouse_pos)
    
    if not tile_pos:
        return
    
    var clicked_army = get_army_at_position(tile_pos)
    
    if clicked_army and clicked_army.faction_id == player_faction:
        select_army(clicked_army)
    elif clicked_army and clicked_army.faction_id == enemy_faction and selected_army:
        execute_attack_order(selected_army, clicked_army)

func handle_right_click() -> void:
    if not selected_army:
        return
    
    var mouse_pos = get_viewport().get_mouse_position()
    var tile_pos = get_tile_at_position(mouse_pos)
    
    if not tile_pos:
        return
    
    move_army_to(selected_army, tile_pos)

func get_tile_at_position(screen_pos: Vector2) -> Vector2i:
    var world_pos = tile_map.to_local(screen_pos)
    var tile_pos = Vector2i(int(world_pos.x / 32), int(world_pos.y / 32))
    
    if tile_pos.x < 0 or tile_pos.x >= 50 or tile_pos.y < 0 or tile_pos.y >= 50:
        return null
    
    return tile_pos

func get_army_at_position(tile_pos: Vector2i) -> Army:
    var world_pos = Vector2(tile_pos.x * 32, tile_pos.y * 32)
    
    for army in armies:
        if army.is_queued_for_deletion():
            continue
        
        var distance = army.global_position.distance_to(world_pos)
        if distance < 20:
            return army
    
    return null

func select_army(army: Army) -> void:
    if selected_army:
        selected_army.deselect()
    
    selected_army = army
    army.select()
    army_selected.emit(army)
    
    GameManager.log_event("army_selected", {
        "army_id": army.army_id,
        "faction_id": army.faction_id,
        "unit_count": army.unit_count
    })

func move_army_to(army: Army, destination: Vector2i) -> void:
    var world_dest = Vector2(destination.x * 32, destination.y * 32)
    var path = find_path(army.global_position, world_dest)
    
    if path.size() > 0:
        army.set_path(path)
        army_moved.emit(army)
        
        GameManager.log_event("army_move", {
            "army_id": army.army_id,
            "from": army.global_position,
            "to": world_dest,
            "path_length": path.size()
        })

func find_path(start: Vector2, end: Vector2) -> Array:
    var path = []
    var current = start
    var step = 32.0
    
    while current.distance_to(end) > step:
        var direction = (end - current).normalized()
        var next_pos = current + direction * step
        
        path.append(next_pos)
        current = next_pos
        
        if path.size() > 100:
            break
    
    return path

func execute_attack_order(attacker: Army, defender: Army) -> void:
    if attacker.faction_id == defender.faction_id:
        return
    
    var result = calculate_combat(attacker, defender)
    
    apply_combat_result(attacker, defender, result)
    attack_order_executed.emit(attacker, defender, result)
    
    GameManager.log_event("attack_order", {
        "attacker_id": attacker.army_id,
        "defender_id": defender.army_id,
        "result": result
    })

func calculate_combat(attacker: Army, defender: Army) -> Dictionary:
    var attacker_power = calculate_army_power(attacker, defender)
    var defender_power = calculate_army_power(defender, attacker)
    
    var ratio = attacker_power / defender_power if defender_power > 0 else 2.0
    
    var result_type = ""
    var attacker_losses = 0
    var defender_losses = 0
    var attacker_morale_change = 0
    var defender_morale_change = 0
    
    if ratio >= 1.5:
        result_type = "quick_victory"
        defender_losses = int(defender.unit_count * 0.3)
        defender_morale_change = -20
        attacker_morale_change = 10
    elif ratio >= 1.1:
        result_type = "victory"
        defender_losses = int(defender.unit_count * 0.15)
        attacker_losses = int(attacker.unit_count * 0.05)
        defender_morale_change = -10
    elif ratio >= 0.9:
        result_type = "stalemate"
        attacker_losses = int(attacker.unit_count * 0.1)
        defender_losses = int(defender.unit_count * 0.1)
        attacker_morale_change = -5
        defender_morale_change = -5
    else:
        result_type = "defeat"
        attacker_losses = int(attacker.unit_count * 0.2)
        attacker_morale_change = -20
        defender_morale_change = 10
    
    return {
        "type": result_type,
        "attacker_power": attacker_power,
        "defender_power": defender_power,
        "ratio": ratio,
        "attacker_losses": attacker_losses,
        "defender_losses": defender_losses,
        "attacker_morale_change": attacker_morale_change,
        "defender_morale_change": defender_morale_change
    }

func calculate_army_power(army: Army, opponent: Army) -> float:
    var base_power = float(army.unit_count) * (float(army.morale) / 100.0)
    
    var terrain_bonus = get_terrain_bonus(army.position)
    var terrain_defense = get_terrain_defense(opponent.position)
    
    var final_power = base_power * (1.0 + terrain_bonus - terrain_defense)
    var charisma_bonus = GameManager.get_skill_effect("charisma")
    
    if army.faction_id == player_faction:
        final_power *= (1.0 + charisma_bonus)
    
    return final_power

func get_terrain_bonus(position: Vector2) -> float:
    var terrain_type = get_terrain_at_position(position)
    
    match terrain_type:
        "plains":
            return 0.0
        "forest":
            return 0.1
        "mountains":
            return -0.1
        _:
            return 0.0

func get_terrain_defense(position: Vector2) -> float:
    var terrain_type = get_terrain_at_position(position)
    
    match terrain_type:
        "plains":
            return 0.0
        "forest":
            return 0.1
        "mountains":
            return 0.2
        _:
            return 0.0

func get_terrain_at_position(position: Vector2) -> String:
    return "plains"

func apply_combat_result(attacker: Army, defender: Army, result: Dictionary) -> void:
    attacker.unit_count -= result["attacker_losses"]
    defender.unit_count -= result["defender_losses"]
    
    attacker.morale = clamp(attacker.morale + result["attacker_morale_change"], 0, 100)
    defender.morale = clamp(defender.morale + result["defender_morale_change"], 0, 100)
    
    if attacker.unit_count <= 0:
        attacker.destroy()
    if defender.unit_count <= 0:
        defender.destroy()

func get_player_armies() -> Array:
    var player_armies = []
    for army in armies:
        if army.faction_id == player_faction and not army.is_queued_for_deletion():
            player_armies.append(army)
    return player_armies

func get_enemy_armies() -> Array:
    var enemy_armies = []
    for army in armies:
        if army.faction_id == enemy_faction and not army.is_queued_for_deletion():
            enemy_armies.append(army)
    return enemy_armies

func get_armies_in_range(position: Vector2, range_tiles: int) -> Array:
    var range_px = range_tiles * 32
    var in_range = []
    
    for army in armies:
        if army.is_queued_for_deletion():
            continue
        var distance = army.global_position.distance_to(position)
        if distance <= range_px:
            in_range.append(army)
    
    return in_range
