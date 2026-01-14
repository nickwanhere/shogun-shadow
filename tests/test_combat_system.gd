extends GutTest

var character: CharacterBody2D
var script_instance: Character

func before_each() -> void:
    character = CharacterBody2D.new()
    script_instance = Character.new()
    character.add_child(script_instance)
    add_child_autofree(character)
    script_instance.health = 100
    script_instance.stamina = 100
    script_instance.attack_direction = 0

func test_block_timing_perfect_parry() -> void:
    script_instance.block(true)
    await wait_seconds(0.05)
    var damage = script_instance.calculate_blocked_damage(20, "perfect_parry")
    assert_eq(damage, 0, "Perfect parry should block all damage")

func test_block_timing_partial_block() -> void:
    script_instance.block(true)
    await wait_seconds(0.2)
    var damage = script_instance.calculate_blocked_damage(20, "partial_block")
    assert_eq(damage, 10, "Partial block should reduce damage by 50%")

func test_block_timing_failed_block() -> void:
    script_instance.block(true)
    await wait_seconds(0.4)
    var damage = script_instance.calculate_blocked_damage(20, "failed_block")
    assert_eq(damage, 20, "Failed block should not reduce damage")

func test_attack_directions() -> void:
    for dir in range(4):
        script_instance.attack_direction = dir
        var damage = script_instance.calculate_damage()
        assert_true(damage >= 8 and damage <= 15, "Attack damage should be valid range")

func test_hit_location_multipliers() -> void:
    var head_mult = script_instance.get_hit_multiplier("head")
    assert_eq(head_mult, 1.5, "Head hit multiplier should be 1.5")
    
    var body_mult = script_instance.get_hit_multiplier("body")
    assert_eq(body_mult, 1.0, "Body hit multiplier should be 1.0")
    
    var legs_mult = script_instance.get_hit_multiplier("legs")
    assert_eq(legs_mult, 0.8, "Legs hit multiplier should be 0.8")

func test_attack_stamina_cost() -> void:
    var initial_stamina = script_instance.stamina
    script_instance.attack()
    assert_eq(script_instance.stamina, initial_stamina - 15, "Attack should cost 15 stamina")

func test_block_stamina_cost() -> void:
    script_instance.block(true)
    var block_result = script_instance.check_block_timing(0)
    var final_stamina = script_instance.stamina
    
    if block_result != "none":
        assert_eq(final_stamina, 95, "Block should cost 5 stamina")

func test_death_at_zero_health() -> void:
    script_instance.take_damage(100)
    assert_true(script_instance.health <= 0, "Character should die at zero health")

func test_multiple_attacks() -> void:
    var initial_health = 100
    for i in range(5):
        script_instance.attack()
    await wait_seconds(1.0)
    assert_true(script_instance.health < initial_health, "Multiple attacks should damage enemy")

func test_directional_blocking() -> void:
    script_instance.attack_direction = 0
    script_instance.block(true)
    
    var same_dir_block = script_instance.check_block_timing(0)
    assert_true(same_dir_block != "none", "Same direction should be blocked")
    
    var diff_dir_block = script_instance.check_block_timing(1)
    assert_eq(diff_dir_block, "none", "Different direction should not block")

func test_stamina_regeneration() -> void:
    script_instance.stamina = 50
    await wait_seconds(1.0)
    assert_true(script_instance.stamina > 50, "Stamina should regenerate")
    assert_true(script_instance.stamina <= 100, "Stamina should not exceed max")

func test_enemy_detection() -> void:
    var enemies = script_instance.get_enemies_in_range(0)
    assert_eq(enemies.size(), 0, "Should detect enemies in attack range")
