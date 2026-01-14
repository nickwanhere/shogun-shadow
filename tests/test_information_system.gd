extends GutTest

var scout: Scout

func before_each() -> void:
    scout = Scout.new()
    scout.scout_id = 0
    scout.faction_id = 0
    add_child_autofree(scout)

func test_scout_initialization() -> void:
    assert_false(scout.is_active, "Scout should be inactive initially")
    assert_false(scout.is_deployed, "Scout should not be deployed initially")
    assert_eq(scout.scout_level, 1, "Scout should start at level 1")

func test_scout_deployment() -> void:
    scout.deploy_at(Vector2(10, 10))
    assert_true(scout.is_deployed, "Scout should be deployed")
    assert_true(scout.is_active, "Scout should be active")
    assert_eq(scout.deployment_position, Vector2(10, 10), "Position should be set")

func test_distance_multiplier_near() -> void:
    scout.deployment_position = Vector2(25, 25)
    var multiplier = scout.calculate_distance_multiplier(Vector2(30, 25))
    assert_eq(multiplier, 1.0, "Near distance should have 1.0x multiplier")

func test_distance_multiplier_medium() -> void:
    scout.deployment_position = Vector2(25, 25)
    var multiplier = scout.calculate_distance_multiplier(Vector2(35, 25))
    assert_eq(multiplier, 2.5, "Medium distance should have 2.5x multiplier")

func test_distance_multiplier_far() -> void:
    scout.deployment_position = Vector2(25, 25)
    var multiplier = scout.calculate_distance_multiplier(Vector2(50, 25))
    assert_eq(multiplier, 5.0, "Far distance should have 5.0x multiplier")

func test_retrieval_time_calculation() -> void:
    scout.deployment_position = Vector2(25, 25)
    scout.deploy_at(Vector2(50, 25))
    assert_eq(scout.retrieval_time, 50.0, "Far distance should have 50s retrieval time")

func test_scout_recall() -> void:
    scout.deploy_at(Vector2(10, 10))
    scout.recall()
    assert_false(scout.is_active, "Scout should be inactive after recall")
    assert_false(scout.is_deployed, "Scout should not be deployed after recall")

func test_accuracy_calculation() -> void:
    scout.scout_level = 1
    var accuracy1 = scout.calculate_accuracy()
    assert_true(accuracy1 >= 0.65 and accuracy1 <= 0.7, "Level 1 should have ~65-70% accuracy")
    
    scout.scout_level = 3
    var accuracy3 = scout.calculate_accuracy()
    assert_true(accuracy3 >= 0.75 and accuracy3 <= 0.8, "Level 3 should have ~75-80% accuracy")

func test_upgrade_level() -> void:
    scout.scout_level = 1
    scout.upgrade_level()
    assert_eq(scout.scout_level, 2, "Scout level should increase")

func test_upgrade_max_level() -> void:
    scout.scout_level = 5
    scout.upgrade_level()
    assert_eq(scout.scout_level, 5, "Scout should not exceed max level")

func test_gather_troop_positions() -> void:
    scout.deploy_at(Vector2(25, 25))
    scout.faction_id = 0
    scout.information_accuracy = 0.8
    
    var positions = scout.gather_troop_positions()
    assert_true(positions is Dictionary, "Should return dictionary")
    assert_true(positions.size() >= 0, "Should have data structure")

func test_scout_progress() -> void:
    scout.deploy_at(Vector2(25, 25))
    var progress_percent = (scout.current_retrieval_time / scout.retrieval_time) * 100.0
    assert_true(progress_percent >= 0.0 and progress_percent <= 100.0, "Progress should be valid percentage")

func test_information_retrieval_completion() -> void:
    scout.deploy_at(Vector2(25, 25))
    await wait_seconds(11.0)
    assert_false(scout.is_retrieving, "Scout should complete retrieval")

func test_visibility_changes() -> void:
    assert_false(scout.visible, "Scout should be invisible initially")
    scout.deploy_at(Vector2(10, 10))
    assert_true(scout.visible, "Scout should be visible when deployed")

var information_display: InformationDisplay

func before_each() -> void:
    information_display = InformationDisplay.new()
    add_child_autofree(information_display)

func test_add_information() -> void:
    var info = {
        "info_type": "troop_positions",
        "data": {"test": "data"},
        "accuracy": 0.8,
        "source": "test"
    }
    
    var initial_count = information_display.get_information_count()
    information_display.add_information(info)
    assert_eq(information_display.get_information_count(), initial_count + 1, "Should add information")

func test_get_average_accuracy() -> void:
    information_display.add_information({"accuracy": 0.8})
    information_display.add_information({"accuracy": 0.9})
    information_display.add_information({"accuracy": 0.7})
    
    var avg = information_display.get_average_accuracy()
    assert_true(abs(avg - 0.8) < 0.01, "Average should be 0.8")

func test_cleanup_old_information() -> void:
    information_display.max_info_age = 1.0
    information_display.add_information({"data": "test1"})
    await wait_seconds(1.2)
    
    information_display.cleanup_old_information()
    var count = information_display.get_information_count()
    assert_eq(count, 0, "Old information should be cleaned up")

func test_filter_by_type() -> void:
    information_display.add_information({"info_type": "troop_positions", "data": {"a": 1}})
    information_display.add_information({"info_type": "enemy_strength", "data": {"b": 2}})
    information_display.add_information({"info_type": "troop_positions", "data": {"c": 3}})
    
    var troop_info = information_display.get_information_by_type("troop_positions")
    assert_eq(troop_info.size(), 2, "Should filter by type correctly")

func test_clear_all_information() -> void:
    information_display.add_information({"data": "test1"})
    information_display.add_information({"data": "test2"})
    
    information_display.clear_all_information()
    assert_eq(information_display.get_information_count(), 0, "Should clear all information")

func test_accuracy_badge_color() -> void:
    assert_true(information_display.get_info_type_color("troop_positions") == Color.CYAN, "Troop positions should be cyan")
    assert_true(information_display.get_info_type_color("enemy_strength") == Color.ORANGE, "Enemy strength should be orange")

func test_format_info_data() -> void:
    var data = {"unit_count": 100, "morale": 80, "position": Vector2(25, 25)}
    var formatted = information_display.format_info_data(data)
    assert_true("unit_count" in formatted, "Should contain unit_count")
    assert_true("morale" in formatted, "Should contain morale")
    assert_true("position" in formatted, "Should contain position")

func test_empty_information_display() -> void:
    information_display.clear_all_information()
    assert_eq(information_display.get_information_count(), 0, "Should be empty initially")

func test_info_timestamp() -> void:
    var info = {"data": "test"}
    information_display.add_information(info)
    var items = information_display.information_items
    
    assert_true(items[0].has("timestamp"), "Should have timestamp")
    assert_true(items[0].get("timestamp", 0.0) > 0, "Timestamp should be positive")
