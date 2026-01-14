extends GutTest

var army_command_system: ArmyCommandSystem
var enemy_ai: EnemyAI

func before_each() -> void:
    army_command_system = ArmyCommandSystem.new()
    add_child_autofree(army_command_system)
    army_command_system.setup_armies()
    
    enemy_ai = EnemyAI.new()
    enemy_ai.command_system = army_command_system
    add_child_autofree(enemy_ai)
    enemy_ai.setup_ai()
    enemy_ai.update_enemy_armies()

func test_step4_armies_display() -> void:
    assert_true(army_command_system.armies.size() > 0, "Armies should be created")
    
    for army in army_command_system.armies:
        assert_true(army.sprite != null, "Each army should have a sprite")
        assert_true(army.selection_indicator != null, "Each army should have selection indicator")

func test_step4_selection_feedback() -> void:
    var player_armies = army_command_system.get_player_armies()
    assert_true(player_armies.size() > 0, "Should have player armies")
    
    var army = player_armies[0]
    assert_false(army.is_selected, "Army should not be initially selected")
    
    army_command_system.select_army(army)
    assert_true(army.is_selected, "Army should be selected after selection")
    assert_true(army.selection_indicator.visible, "Selection indicator should be visible")
    
    army.deselect()
    assert_false(army.is_selected, "Army should be deselected")
    assert_false(army.selection_indicator.visible, "Selection indicator should be hidden")

func test_step4_movement_to_destination() -> void:
    var player_armies = army_command_system.get_player_armies()
    assert_true(player_armies.size() > 0, "Should have player armies")
    
    var army = player_armies[0]
    var destination = Vector2i(int(army.position.x / 32) + 3, int(army.position.y / 32) + 2)
    var initial_position = army.global_position
    
    army_command_system.move_army_to(army, destination)
    
    var target_pos = Vector2(destination.x * 32, destination.y * 32)
    assert_true(army.global_position.distance_to(target_pos) < initial_position.distance_to(target_pos), 
        "Army should move toward destination")

func test_step4_pathfinding() -> void:
    var start = Vector2(0, 0)
    var end = Vector2(160, 160)
    var path = army_command_system.find_path(start, end)
    
    assert_true(path.size() > 0, "Should find a path")
    assert_true(path[0].distance_to(start) < 10, "Path should start near start")
    assert_true(path[-1].distance_to(end) < 10, "Path should end near end")

func test_step4_attack_orders_execute() -> void:
    var player_armies = army_command_system.get_player_armies()
    var enemy_armies = army_command_system.get_enemy_armies()
    
    if player_armies.is_empty() or enemy_armies.is_empty():
        skip_test("Need both player and enemy armies")
    
    var attacker = player_armies[0]
    var defender = enemy_armies[0]
    var initial_attacker_units = attacker.unit_count
    var initial_defender_units = defender.unit_count
    
    army_command_system.execute_attack_order(attacker, defender)
    
    var units_changed = attacker.unit_count != initial_attacker_units or defender.unit_count != initial_defender_units
    assert_true(units_changed, "Attack should change unit counts")

func test_step4_combat_calculations() -> void:
    var attacker = create_test_army(0, 60, 100)
    var defender = create_test_army(1, 50, 90)
    
    var result = army_command_system.calculate_combat(attacker, defender)
    
    assert_true(result.has("type"), "Result should have type")
    assert_true(result.has("attacker_power"), "Result should have attacker power")
    assert_true(result.has("defender_power"), "Result should have defender power")
    assert_true(result.has("ratio"), "Result should have power ratio")
    assert_true(result.has("attacker_losses"), "Result should have attacker losses")
    assert_true(result.has("defender_losses"), "Result should have defender losses")

func test_step4_enemy_ai_moves() -> void:
    if enemy_ai.enemy_armies.is_empty():
        skip_test("No enemy armies")
    
    var army = enemy_ai.enemy_armies[0]
    var initial_position = army.global_position
    
    var move_decision = enemy_ai.create_move_decision(army)
    enemy_ai.execute_decision(army, move_decision)
    
    assert_true(army.global_position.distance_to(initial_position) > 0, 
        "Enemy AI should move army")

func test_step4_enemy_ai_attacks() -> void:
    var player_armies = army_command_system.get_player_armies()
    if enemy_ai.enemy_armies.is_empty() or player_armies.is_empty():
        skip_test("Need both enemy and player armies")
    
    var army = enemy_ai.enemy_armies[0]
    var targets = player_armies
    
    var attack_decision = enemy_ai.create_attack_decision(army, targets)
    enemy_ai.execute_decision(army, attack_decision)
    
    assert_eq(attack_decision.type, "attack", "Decision should be attack type")

func test_step4_terrain_bonuses() -> void:
    var plains_power = army_command_system.calculate_army_power(create_test_army(0, 50, 100), create_test_army(1, 50, 100))
    
    var army_with_forest = create_test_army(0, 50, 100)
    army_with_forest.position = Vector2(100, 100)
    var forest_power = army_command_system.calculate_army_power(army_with_forest, create_test_army(1, 50, 100))
    
    var power_diff = forest_power - plains_power
    assert_true(power_diff >= 0, "Forest should provide bonus or no penalty")

func test_step4_army_unit_types() -> void:
    army_command_system.setup_armies()
    
    var types_found = {}
    for army in army_command_system.armies:
        types_found[army.unit_type] = true
    
    assert_true(types_found.has("infantry") or types_found.has("cavalry") or types_found.has("archers"), 
        "Armies should have valid unit types")

func test_step4_morale_system() -> void:
    var attacker = create_test_army(0, 50, 100)
    var defender = create_test_army(1, 30, 50)
    
    var result = army_command_system.calculate_combat(attacker, defender)
    army_command_system.apply_combat_result(attacker, defender, result)
    
    assert_true(defender.morale < 50, "Defender morale should decrease")
    assert_true(attacker.morale >= 0 and attacker.morale <= 100, "Attacker morale should be in range")

func test_step4_army_destruction() -> void:
    var army = create_test_army(0, 5, 50)
    
    army.take_damage(100)
    
    assert_true(army.unit_count <= 0, "Army should be destroyed")
    assert_true(army.is_queued_for_deletion(), "Army should be queued for deletion")

func test_step4_ai_decision_timer() -> void:
    assert_eq(enemy_ai.decision_timer, 0.0, "Timer should start at 0")
    
    enemy_ai._process(5.0)
    
    assert_eq(enemy_ai.decision_timer, 0.0, "Timer should reset after 5 seconds")

func test_step4_click_to_select() -> void:
    var player_armies = army_command_system.get_player_armies()
    if player_armies.is_empty():
        skip_test("No player armies")
    
    var army = player_armies[0]
    army_command_system.select_army(army)
    
    assert_true(army_command_system.selected_army == army, "Selected army should match")
    assert_true(army.is_selected, "Army should be marked as selected")

func create_test_army(faction_id: int, unit_count: int, morale: int) -> Army:
    var army = Army.new()
    army.army_id = 999
    army.faction_id = faction_id
    army.unit_count = unit_count
    army.unit_type = "infantry"
    army.morale = morale
    army.supplies = 50
    army.position = Vector2(0, 0)
    return army
