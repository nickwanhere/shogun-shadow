extends GutTest

var game_manager: GameManager

func before_each() -> void:
    game_manager = GameManager.new()
    add_child_autofree(game_manager)
    game_manager.initialize_game_state()

func test_initial_state() -> void:
    assert_eq(game_manager.game_state["player_health"], 100, "Player health should start at 100")
    assert_eq(game_manager.game_state["player_stamina"], 100, "Player stamina should start at 100")

func test_player_position_update() -> void:
    game_manager.update_player_position(Vector2(10, 10))
    assert_eq(game_manager.game_state["player_position"], Vector2(10, 10), "Player position should update")

func test_player_health_clamp() -> void:
    game_manager.update_player_health(150)
    assert_eq(game_manager.game_state["player_health"], 100, "Health should clamp to max")
    
    game_manager.update_player_health(-10)
    assert_eq(game_manager.game_state["player_health"], 0, "Health should clamp to min")

func test_player_stamina_clamp() -> void:
    game_manager.update_player_stamina(150)
    assert_eq(game_manager.game_state["player_stamina"], 100, "Stamina should clamp to max")
    
    game_manager.update_player_stamina(-10)
    assert_eq(game_manager.game_state["player_stamina"], 0, "Stamina should clamp to min")

func test_skill_effect() -> void:
    var effect = game_manager.get_skill_effect("tactical_insight")
    assert_true(effect > 0, "Skill effect should be positive")

func test_information_accuracy() -> void:
    var accuracy = game_manager.get_information_accuracy()
    assert_true(accuracy >= 0.0 and accuracy <= 1.0, "Accuracy should be between 0 and 1")

func test_fog_of_war_creation() -> void:
    var fog = game_manager.create_initial_fog_of_war()
    assert_eq(fog.size(), 50, "Fog should have 50 columns")
    assert_eq(fog[0].size(), 50, "Fog should have 50 rows per column")

func test_fog_of_war_reveal() -> void:
    game_manager.reveal_fog_of_war(Vector2(25, 25), 5)
    assert_false(game_manager.game_state["fog_of_war"][25][25], "Center tile should be revealed")
    assert_false(game_manager.game_state["fog_of_war"][30][25], "Nearby tile should be revealed")

func test_event_logging() -> void:
    game_manager.log_event("test_event", {"data": "test_value"})
    assert_eq(game_manager.game_state["events"].size(), 2, "Two events should be logged (init + test)")

func test_state_export() -> void:
    var state = game_manager.export_state()
    assert_true(state.has("player_position"), "Exported state should have player position")
    assert_true(state.has("player_health"), "Exported state should have player health")

func test_state_import() -> void:
    var new_state = {
        "player_position": Vector2(5, 5),
        "player_health": 50,
        "player_stamina": 75
    }
    game_manager.import_state(new_state)
    assert_eq(game_manager.game_state["player_position"], Vector2(5, 5), "Imported state should update position")
