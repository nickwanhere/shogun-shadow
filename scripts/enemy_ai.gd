extends Node

class_name EnemyAI

var enemy_armies: Array = []
var player_faction: int = 0
var decision_timer: float = 0.0
var decision_interval: float = 5.0

const AGGRESSIVE_CHANCE: float = 0.4
const MOVE_CHANCE: float = 0.6
const ATTACK_RANGE_TILES: int = 5

signal ai_decision_made(decision: Dictionary)

var command_system: ArmyCommandSystem

func _ready() -> void:
    setup_ai()

func _process(delta: float) -> void:
    decision_timer += delta
    
    if decision_timer >= decision_interval:
        decision_timer = 0.0
        make_ai_decision()

func setup_ai() -> void:
    pass

func make_ai_decision() -> void:
    for army in enemy_armies:
        if army.is_queued_for_deletion():
            continue
        
        var decision = make_army_decision(army)
        execute_decision(army, decision)
        
        ai_decision_made.emit(decision)
        
        GameManager.log_event("ai_decision", {
            "army_id": army.army_id,
            "decision_type": decision.type,
            "target": decision.target
        })

func make_army_decision(army: Army) -> Dictionary:
    var nearby_player_armies = get_nearby_player_armies(army)
    
    if nearby_player_armies.size() > 0 and randf() < AGGRESSIVE_CHANCE:
        return create_attack_decision(army, nearby_player_armies)
    elif randf() < MOVE_CHANCE:
        return create_move_decision(army)
    else:
        return create_idle_decision(army)

func create_attack_decision(army: Army, targets: Array) -> Dictionary:
    var target = targets[randi() % targets.size()]
    
    return {
        "type": "attack",
        "army_id": army.army_id,
        "target_army_id": target.army_id,
        "target_position": target.global_position,
        "confidence": 0.8
    }

func create_move_decision(army: Army) -> Dictionary:
    var move_direction = get_move_direction_toward_player(army)
    var current_tile = Vector2i(int(army.position.x / 32), int(army.position.y / 32))
    var target_tile = current_tile + move_direction
    
    target_tile = Vector2i(
        clamp(target_tile.x, 0, 49),
        clamp(target_tile.y, 0, 49)
    )
    
    return {
        "type": "move",
        "army_id": army.army_id,
        "from_position": army.global_position,
        "to_position": target_tile * 32,
        "confidence": 0.7
    }

func create_idle_decision(army: Army) -> Dictionary:
    return {
        "type": "idle",
        "army_id": army.army_id,
        "position": army.global_position,
        "confidence": 0.5
    }

func get_move_direction_toward_player(army: Army) -> Vector2i:
    var player_armies = command_system.get_player_armies()
    
    if player_armies.is_empty():
        return Vector2i.ZERO
    
    var closest_army = null
    var closest_distance = INF
    
    for player_army in player_armies:
        var distance = army.global_position.distance_to(player_army.global_position)
        if distance < closest_distance:
            closest_distance = distance
            closest_army = player_army
    
    if not closest_army:
        return Vector2i.ZERO
    
    var direction = (closest_army.global_position - army.global_position).normalized()
    return Vector2i(int(direction.x), int(direction.y))

func get_nearby_player_armies(army: Army) -> Array:
    var nearby = []
    var player_armies = command_system.get_player_armies()
    
    for player_army in player_armies:
        var distance = army.global_position.distance_to(player_army.global_position)
        var distance_tiles = int(distance / 32)
        
        if distance_tiles <= ATTACK_RANGE_TILES:
            nearby.append(player_army)
    
    return nearby

func execute_decision(army: Army, decision: Dictionary) -> void:
    match decision.type:
        "attack":
            var target_army = find_army_by_id(decision["target_army_id"])
            if target_army and not target_army.is_queued_for_deletion():
                if command_system:
                    command_system.execute_attack_order(army, target_army)
        "move":
            var target_tile = Vector2i(decision["to_position"].x / 32, decision["to_position"].y / 32)
            if command_system:
                command_system.move_army_to(army, target_tile)
        "idle":
            pass

func find_army_by_id(army_id: int) -> Army:
    if not command_system:
        return null
    
    for army in command_system.armies:
        if army.army_id == army_id and not army.is_queued_for_deletion():
            return army
    
    return null

func update_enemy_armies() -> void:
    if not command_system:
        return
    
    enemy_armies = command_system.get_enemy_armies()
    
    GameManager.log_event("ai_update", {
        "enemy_count": enemy_armies.size()
    })

func get_ai_state() -> Dictionary:
    return {
        "enemy_count": enemy_armies.size(),
        "decision_timer": decision_timer,
        "decision_interval": decision_interval
    }
