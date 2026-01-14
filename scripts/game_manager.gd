extends Node
signal game_state_changed()
signal combat_event(event_data: Dictionary)
signal information_received(info: Dictionary)

var game_state: Dictionary = {
    "player_position": Vector2.ZERO,
    "player_health": 100,
    "player_max_health": 100,
    "player_stamina": 100,
    "player_max_stamina": 100,
    "player_attack_direction": 0,
    "player_is_blocking": false,
    "armies": [],
    "fog_of_war": [],
    "information_sources": [],
    "current_meeting": null,
    "skills": {},
    "events": []
}

func _ready() -> void:
    initialize_game_state()
    log_event("game_start", {"message": "Game initialized"})

func initialize_game_state() -> void:
    game_state["player_position"] = Vector2(25, 25)
    game_state["fog_of_war"] = create_initial_fog_of_war()
    game_state["skills"] = {
        "tactical_insight": {"level": 1, "magnitude": 0.1},
        "charisma": {"level": 1, "magnitude": 0.05}
    }
    game_state["armies"] = []
    game_state["information_sources"] = []
    game_state["events"] = []
    game_state_changed.emit()

func export_state() -> Dictionary:
    return game_state.duplicate(true)

func import_state(state: Dictionary) -> void:
    game_state = state.duplicate(true)
    apply_state_changes()
    game_state_changed.emit()

func apply_state_changes() -> void:
    pass

func log_event(event_type: String, data: Dictionary) -> void:
    var event = {
        "type": event_type,
        "data": data,
        "timestamp": Time.get_unix_time_from_system()
    }
    game_state["events"].append(event)
    print("[%s] %s" % [event_type, str(data)])
    
    if event_type == "combat":
        combat_event.emit(event)
    elif event_type == "information":
        information_received.emit(event)

func update_player_position(new_position: Vector2) -> void:
    game_state["player_position"] = new_position
    game_state_changed.emit()

func update_player_health(health: int) -> void:
    game_state["player_health"] = clamp(health, 0, game_state["player_max_health"])
    if game_state["player_health"] <= 0:
        log_event("player_death", {"message": "Player died"})
    game_state_changed.emit()

func update_player_stamina(stamina: int) -> void:
    game_state["player_stamina"] = clamp(stamina, 0, game_state["player_max_stamina"])
    game_state_changed.emit()

func create_initial_fog_of_war() -> Array:
    var fog: Array = []
    for x in range(50):
        fog.append([])
        for y in range(50):
            fog[x].append(true)
    return fog

func reveal_fog_of_war(position: Vector2, radius: int) -> void:
    var px: int = int(position.x)
    var py: int = int(position.y)
    
    for x in range(px - radius, px + radius + 1):
        for y in range(py - radius, py + radius + 1):
            if x >= 0 and x < 50 and y >= 0 and y < 50:
                var distance = sqrt(float((x - px) * (x - px) + (y - py) * (y - py)))
                if distance <= radius:
                    game_state["fog_of_war"][x][y] = false
    
    game_state_changed.emit()

func get_skill_effect(skill_name: String) -> float:
    if skill_name in game_state["skills"]:
        var skill = game_state["skills"][skill_name]
        return skill["magnitude"] * skill["level"]
    return 0.0

func get_information_accuracy() -> float:
    var base_accuracy: float = 0.7
    var tactical_insight_bonus: float = get_skill_effect("tactical_insight")
    return min(base_accuracy + tactical_insight_bonus, 1.0)
