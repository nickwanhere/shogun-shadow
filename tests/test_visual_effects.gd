extends GutTest

var damage_indicator: DamageIndicator

func before_each() -> void:
    damage_indicator = DamageIndicator.new()
    add_child_autofree(damage_indicator)

func test_damage_indicator_initialization() -> void:
    damage_indicator.initialize(25, Vector2(100, 100), Color.RED)
    assert_eq(damage_indicator.damage, 25, "Damage should be set")
    assert_eq(damage_indicator.position, Vector2(100, 100), "Position should be set")

func test_damage_indicator_lifetime() -> void:
    damage_indicator.initialize(10, Vector2(50, 50), Color.RED)
    var initial_y = damage_indicator.position.y
    await wait_seconds(0.5)
    assert_true(damage_indicator.position.y < initial_y, "Indicator should move up")

func test_damage_indicator_fade() -> void:
    damage_indicator.initialize(15, Vector2(100, 100), Color.RED)
    await wait_seconds(0.5)
    assert_true(damage_indicator.label.modulate.a < 1.0, "Label should fade")

func test_damage_indicator_cleanup() -> void:
    damage_indicator.initialize(20, Vector2(100, 100), Color.RED)
    await wait_seconds(1.2)
    assert_true(damage_indicator.is_queued_for_deletion(), "Indicator should be freed after lifetime")

func test_damage_indicator_colors() -> void:
    damage_indicator.initialize(30, Vector2(50, 50), Color.GOLD)
    assert_eq(damage_indicator.color, Color.GOLD, "Custom color should be applied")

var attack_visualizer: AttackVisualizer

func before_each() -> void:
    attack_visualizer = AttackVisualizer.new()
    attack_visualizer.is_player = true
    add_child_autofree(attack_visualizer)

func test_attack_visualizer_idle_state() -> void:
    assert_false(attack_visualizer.visible, "Should be invisible when idle")
    assert_eq(attack_visualizer.attack_phase, "idle", "Should start in idle phase")

func test_attack_visualizer_windup_phase() -> void:
    attack_visualizer.start_attack(0, "slash")
    await wait_seconds(0.1)
    assert_eq(attack_visualizer.attack_phase, "windup", "Should be in windup phase")
    assert_true(attack_visualizer.visible, "Should be visible during attack")

func test_attack_visualizer_attack_phase() -> void:
    attack_visualizer.start_attack(0, "slash")
    await wait_seconds(0.35)
    assert_eq(attack_visualizer.attack_phase, "attack", "Should transition to attack phase")

func test_attack_visualizer_recovery_phase() -> void:
    attack_visualizer.start_attack(0, "slash")
    await wait_seconds(0.6)
    assert_eq(attack_visualizer.attack_phase, "recovery", "Should transition to recovery phase")

func test_attack_visualizer_completion() -> void:
    attack_visualizer.start_attack(0, "slash")
    await wait_seconds(1.1)
    assert_eq(attack_visualizer.attack_phase, "idle", "Should return to idle")
    assert_false(attack_visualizer.visible, "Should be invisible after completion")

func test_attack_visualizer_directions() -> void:
    for dir in range(4):
        attack_visualizer.start_attack(dir, "slash")
        await wait_seconds(0.1)
        assert_true(attack_visualizer.visible, "Attack should be visible in direction %d" % dir)
        await wait_seconds(1.1)

func test_attack_visualizer_damage_calculation() -> void:
    var damage = attack_visualizer.calculate_attack_damage()
    assert_true(damage >= 8 and damage <= 15, "Damage should be in valid range")

var block_visualizer: BlockVisualizer

func before_each() -> void:
    block_visualizer = BlockVisualizer.new()
    block_visualizer.is_player = true
    add_child_autofree(block_visualizer)

func test_block_visualizer_initialization() -> void:
    assert_false(block_visualizer.visible, "Should be invisible initially")
    assert_false(block_visualizer.is_blocking, "Should not be blocking")

func test_block_visualizer_activation() -> void:
    block_visualizer.start_block(0)
    assert_true(block_visualizer.visible, "Should be visible when blocking")
    assert_true(block_visualizer.is_blocking, "Should be blocking state")

func test_block_visualizer_deactivation() -> void:
    block_visualizer.start_block(0)
    block_visualizer.stop_block()
    assert_false(block_visualizer.visible, "Should be invisible when stopped")
    assert_false(block_visualizer.is_blocking, "Should not be blocking state")

func test_block_visualizer_directions() -> void:
    for dir in range(4):
        block_visualizer.start_block(dir)
        assert_eq(block_visualizer.block_direction, dir, "Direction should be set to %d" % dir)
        block_visualizer.stop_block()

func test_block_visualizer_timing_perfect() -> void:
    block_visualizer.start_block(0)
    var block_type = block_visualizer.check_block(0, Time.get_unix_time_from_system() + 0.05)
    assert_eq(block_type, "perfect_parry", "Should detect perfect parry window")

func test_block_visualizer_timing_partial() -> void:
    block_visualizer.start_block(0)
    var block_type = block_visualizer.check_block(0, Time.get_unix_time_from_system() + 0.2)
    assert_eq(block_type, "partial_block", "Should detect partial block window")

func test_block_visualizer_timing_failed() -> void:
    block_visualizer.start_block(0)
    var block_type = block_visualizer.check_block(0, Time.get_unix_time_from_system() + 0.4)
    assert_eq(block_type, "failed_block", "Should detect failed block")

func test_block_visualizer_damage_reduction() -> void:
    assert_eq(block_visualizer.get_damage_reduction("perfect_parry"), 1.0, "Perfect parry should block 100%")
    assert_eq(block_visualizer.get_damage_reduction("partial_block"), 0.5, "Partial block should block 50%")
    assert_eq(block_visualizer.get_damage_reduction("failed_block"), 0.0, "Failed block should block 0%")
