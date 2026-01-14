extends GutTest

var enemy_ai: EnemyAI
var army_command_system: ArmyCommandSystem
var test_attacker: Army
var test_defender: Army

func before_each() -> void:
    army_command_system = ArmyCommandSystem.new()
    add_child_autofree(army_command_system)
    army_command_system.setup_armies()
    
    enemy_ai = EnemyAI.new()
    enemy_ai.command_system = army_command_system
    add_child_autofree(enemy_ai)
    enemy_ai.setup_ai()
    enemy_ai.update_enemy_armies()

func test_ai_setup() -> void:
    assert_true(enemy_ai.enemy_armies.size() > 0, "AI should have enemy armies")
    assert_eq(enemy_ai.decision_interval, 5.0, "Decision interval should be 5.0")
    assert_eq(enemy_ai.decision_timer, 0.0, "Timer should start at 0")

func test_ai_makes_decision() -> void:
    var initial_timer = enemy_ai.decision_timer
    
    enemy_ai._process(5.0)
    
    assert_eq(enemy_ai.decision_timer, 0.0, "Timer should reset after 5 seconds")
    assert_true(enemy_ai.enemy_armies.size() > 0, "Should still have armies after decision")

func test_attack_decision() -> void:
    if enemy_ai.enemy_armies.is_empty():
        return
    
    var army = enemy_ai.enemy_armies[0]
    var player_armies = army_command_system.get_player_armies()
    
    if player_armies.is_empty():
        return
    
    var decision = enemy_ai.create_attack_decision(army, player_armies)
    
    assert_eq(decision.type, "attack", "Should create attack decision")
    assert_true(decision.has("army_id"), "Should have army ID")
    assert_true(decision.has("target_army_id"), "Should have target army ID")
    assert_true(decision.has("target_position"), "Should have target position")
    assert_true(decision.has("confidence"), "Should have confidence")

func test_move_decision() -> void:
    if enemy_ai.enemy_armies.is_empty():
        return
    
    var army = enemy_ai.enemy_armies[0]
    var decision = enemy_ai.create_move_decision(army)
    
    assert_eq(decision.type, "move", "Should create move decision")
    assert_true(decision.has("army_id"), "Should have army ID")
    assert_true(decision.has("from_position"), "Should have from position")
    assert_true(decision.has("to_position"), "Should have to position")
    assert_true(decision.has("confidence"), "Should have confidence")

func test_idle_decision() -> void:
    if enemy_ai.enemy_armies.is_empty():
        return
    
    var army = enemy_ai.enemy_armies[0]
    var decision = enemy_ai.create_idle_decision(army)
    
    assert_eq(decision.type, "idle", "Should create idle decision")
    assert_true(decision.has("army_id"), "Should have army ID")
    assert_true(decision.has("position"), "Should have position")
    assert_true(decision.has("confidence"), "Should have confidence")

func test_army_decision_logic() -> void:
    if enemy_ai.enemy_armies.is_empty():
        return
    
    var army = enemy_ai.enemy_armies[0]
    var decision = enemy_ai.make_army_decision(army)
    
    assert_true(decision.type in ["attack", "move", "idle"], "Decision should be valid type")

func test_nearby_player_armies() -> void:
    if enemy_ai.enemy_armies.is_empty():
        return
    
    var army = enemy_ai.enemy_armies[0]
    var nearby = enemy_ai.get_nearby_player_armies(army)
    
    assert_true(nearby is Array, "Should return array")
    for nearby_army in nearby:
        var distance = army.global_position.distance_to(nearby_army.global_position)
        var distance_tiles = int(distance / 32)
        assert_true(distance_tiles <= enemy_ai.ATTACK_RANGE_TILES, "All armies should be in attack range")

func test_move_direction_toward_player() -> void:
    if enemy_ai.enemy_armies.is_empty():
        return
    
    var army = enemy_ai.enemy_armies[0]
    var direction = enemy_ai.get_move_direction_toward_player(army)
    
    assert_true(direction.x >= -1 and direction.x <= 1, "X direction should be valid")
    assert_true(direction.y >= -1 and direction.y <= 1, "Y direction should be valid")

func test_execute_attack_decision() -> void:
    if enemy_ai.enemy_armies.is_empty():
        return
    
    var player_armies = army_command_system.get_player_armies()
    if player_armies.is_empty():
        return
    
    var attacker = enemy_ai.enemy_armies[0]
    var defender = player_armies[0]
    
    var initial_attacker_units = attacker.unit_count
    var initial_defender_units = defender.unit_count
    
    var decision = {
        "type": "attack",
        "army_id": attacker.army_id,
        "target_army_id": defender.army_id,
        "target_position": defender.global_position,
        "confidence": 0.8
    }
    
    enemy_ai.execute_decision(attacker, decision)
    
    var attacker_changed = attacker.unit_count != initial_attacker_units or defender.unit_count != initial_defender_units
    assert_true(attacker_changed, "Attack should change unit counts")

func test_execute_move_decision() -> void:
    if enemy_ai.enemy_armies.is_empty():
        return
    
    var army = enemy_ai.enemy_armies[0]
    var initial_position = army.global_position
    
    var decision = enemy_ai.create_move_decision(army)
    enemy_ai.execute_decision(army, decision)
    
    assert_true(army.global_position.distance_to(decision["to_position"]) < 50, "Army should move toward target")

func test_execute_idle_decision() -> void:
    if enemy_ai.enemy_armies.is_empty():
        return
    
    var army = enemy_ai.enemy_armies[0]
    var initial_position = army.global_position
    
    var decision = enemy_ai.create_idle_decision(army)
    enemy_ai.execute_decision(army, decision)
    
    assert_eq(army.global_position, initial_position, "Idle should not move army")

func test_find_army_by_id() -> void:
    if enemy_ai.enemy_armies.is_empty():
        return
    
    var army = enemy_ai.enemy_armies[0]
    var found = enemy_ai.find_army_by_id(army.army_id)
    
    assert_true(found != null, "Should find army by ID")
    assert_eq(found.army_id, army.army_id, "Should find correct army")

func test_ai_state_export() -> void:
    enemy_ai.update_enemy_armies()
    var state = enemy_ai.get_ai_state()
    
    assert_true(state.has("enemy_count"), "State should have enemy count")
    assert_true(state.has("decision_timer"), "State should have decision timer")
    assert_true(state.has("decision_interval"), "State should have decision interval")
    assert_eq(state.enemy_count, enemy_ai.enemy_armies.size(), "Count should match")

func test_update_enemy_armies() -> void:
    enemy_ai.update_enemy_armies()
    
    var expected_count = army_command_system.get_enemy_armies().size()
    assert_eq(enemy_ai.enemy_armies.size(), expected_count, "Enemy armies should match command system")

func test_ai_emits_decision_signal() -> void:
    var signal_received = false
    var received_decision = {}
    
    enemy_ai.ai_decision_made.connect(func(decision):
        signal_received = true
        received_decision = decision
    )
    
    if not enemy_ai.enemy_armies.is_empty():
        enemy_ai.make_ai_decision()
        assert_true(signal_received, "AI should emit decision signal")
        assert_true(received_decision.has("type"), "Decision should have type")
