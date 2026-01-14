extends GutTest

var army_command_system: ArmyCommandSystem

func before_each() -> void:
    army_command_system = ArmyCommandSystem.new()
    add_child_autofree(army_command_system)

func test_army_creation() -> void:
    army_command_system.setup_armies()
    assert_eq(army_command_system.armies.size(), 5, "Should create 5 armies (2 player + 3 enemy)")

func test_army_factions() -> void:
    army_command_system.setup_armies()
    var player_count = 0
    var enemy_count = 0
    
    for army in army_command_system.armies:
        if army.faction_id == 0:
            player_count += 1
        else:
            enemy_count += 1
    
    assert_eq(player_count, 2, "Should have 2 player armies")
    assert_eq(enemy_count, 3, "Should have 3 enemy armies")

func test_army_selection() -> void:
    army_command_system.setup_armies()
    var player_armies = army_command_system.get_player_armies()
    assert_true(player_armies.size() > 0, "Should have player armies")
    
    var selected_army = player_armies[0]
    army_command_system.select_army(selected_army)
    assert_true(selected_army.is_selected, "Army should be selected")

func test_pathfinding() -> void:
    var start = Vector2(0, 0)
    var end = Vector2(5 * 32, 5 * 32)
    var path = army_command_system.find_path(start, end)
    
    assert_true(path.size() > 0, "Should find a path")
    assert_true(path.size() <= 6, "Path should be direct (6 steps max for 5 tiles)")

func test_army_movement() -> void:
    army_command_system.setup_armies()
    var player_armies = army_command_system.get_player_armies()
    
    var army = player_armies[0]
    var destination = Vector2i(army.position.x / 32 + 3, army.position.y / 32 + 2)
    
    var initial_pos = army.global_position
    army_command_system.move_army_to(army, destination)
    
    assert_true(army.global_position.distance_to(Vector2(destination.x * 32, destination.y * 32)) < 10, "Army should move toward destination")

func test_combat_calculation() -> void:
    army_command_system.setup_armies()
    var player_armies = army_command_system.get_player_armies()
    var enemy_armies = army_command_system.get_enemy_armies()
    
    if player_armies.is_empty() or enemy_armies.is_empty():
        return
    
    var attacker = player_armies[0]
    var defender = enemy_armies[0]
    
    var result = army_command_system.calculate_combat(attacker, defender)
    assert_true(result.has("type"), "Should have result type")
    assert_true(result.has("attacker_power"), "Should have attacker power")
    assert_true(result.has("defender_power"), "Should have defender power")
    assert_true(result.has("ratio"), "Should have power ratio")

func test_quick_victory() -> void:
    var attacker = create_test_army(0, 100, 100)
    var defender = create_test_army(1, 30, 100)
    
    var result = army_command_system.calculate_combat(attacker, defender)
    assert_eq(result.type, "quick_victory", "3.3x ratio should be quick victory")

func test_victory() -> void:
    var attacker = create_test_army(0, 60, 100)
    var defender = create_test_army(1, 50, 90)
    
    var result = army_command_system.calculate_combat(attacker, defender)
    assert_eq(result.type, "victory", "1.2x ratio should be victory")

func test_stalemate() -> void:
    var attacker = create_test_army(0, 50, 90)
    var defender = create_test_army(1, 50, 95)
    
    var result = army_command_system.calculate_combat(attacker, defender)
    assert_eq(result.type, "stalemate", "1.0x ratio should be stalemate")

func test_defeat() -> void:
    var attacker = create_test_army(0, 30, 80)
    var defender = create_test_army(1, 50, 100)
    
    var result = army_command_system.calculate_combat(attacker, defender)
    assert_eq(result.type, "defeat", "0.8x ratio should be defeat")

func test_army_destruction() -> void:
    army_command_system.setup_armies()
    var player_armies = army_command_system.get_player_armies()
    var enemy_armies = army_command_system.get_enemy_armies()
    
    if player_armies.is_empty() or enemy_armies.is_empty():
        return
    
    var attacker = player_armies[0]
    var defender = enemy_armies[0]
    
    attacker.unit_count = 0
    army_command_system.apply_combat_result(attacker, defender, {
        "type": "defeat",
        "attacker_losses": 0,
        "defender_losses": 10
    })
    
    assert_true(attacker.is_queued_for_deletion(), "Destroyed army should be queued for deletion")

func test_terrain_bonuses() -> void:
    var plains_bonus = army_command_system.get_terrain_bonus(Vector2(0, 0))
    var forest_bonus = army_command_system.get_terrain_bonus(Vector2(100, 100))
    var mountain_bonus = army_command_system.get_terrain_bonus(Vector2(200, 200))
    
    assert_eq(plains_bonus, 0.0, "Plains should have 0.0 bonus")
    assert_eq(forest_bonus, 0.1, "Forest should have 0.1 bonus")
    assert_eq(mountain_bonus, -0.1, "Mountains should have -0.1 bonus")

func test_army_power_calculation() -> void:
    var army = create_test_army(0, 50, 100)
    var power = army_command_system.calculate_army_power(army, create_test_army(1, 50, 100))
    
    var base_power = float(50) * (100.0 / 100.0)
    assert_true(power >= base_power * 0.9, "Power should include terrain bonuses")
    assert_true(power <= base_power * 1.1, "Power should be reasonable")

func test_get_armies_in_range() -> void:
    army_command_system.setup_armies()
    var position = Vector2(25 * 32, 25 * 32)
    var in_range = army_command_system.get_armies_in_range(position, 5)
    
    assert_true(in_range.size() > 0, "Should find armies in range")
    
    for army in in_range:
        var distance = army.global_position.distance_to(position)
        var distance_tiles = int(distance / 32)
        assert_true(distance_tiles <= 5, "All armies should be within 5 tiles")

func create_test_army(faction_id: int, unit_count: int, morale: int) -> Army:
    var army = Army.new()
    army.army_id = 0
    army.faction_id = faction_id
    army.unit_count = unit_count
    army.unit_type = "infantry"
    army.morale = morale
    army.supplies = 50
    army.position = Vector2(0, 0)
    return army

func test_multiple_selections() -> void:
    army_command_system.setup_armies()
    var player_armies = army_command_system.get_player_armies()
    
    var selected_armies = []
    for army in player_armies:
        if army.is_selected:
            selected_armies.append(army)
    
    assert_eq(selected_armies.size(), 0, "No armies should be initially selected")

func test_army_unit_types() -> void:
    var types = ["infantry", "cavalry", "archers"]
    army_command_system.setup_armies()
    
    for army in army_command_system.armies:
        assert_true(army.unit_type in types, "All armies should have valid unit type")

func test_army_morale_bounds() -> void:
    for i in range(10):
        var army = create_test_army(0, 50, 80 + randi() % 21)
        assert_true(army.morale >= 80, "Morale should be >= 80")
        assert_true(army.morale <= 100, "Morale should be <= 100")
