extends Node

var tests_passed = 0
var tests_failed = 0
var test_results = []

func _ready() -> void:
	print("=" * 60)
	print("STEP 8: INTEGRATION & VERIFICATION")
	print("=" * 60)
	print()
	
	run_all_tests()
	print_results()
	
	quit_with_code()

func run_all_tests() -> void:
	print("Running integration tests...")
	print()
	
	test_game_manager()
	test_character_system()
	test_army_system()
	test_combat_system()
	test_information_system()
	test_fog_of_war()
	test_meeting_system()
	test_skill_system()
	test_enemy_ai()
	test_assets()
	
	print()
	print(f"Tests run: {tests_passed + tests_failed}")
	print(f"Passed: {tests_passed}")
	print(f"Failed: {tests_failed}")
	print()

func assert_true(condition: bool, test_name: String) -> void:
	if condition:
		tests_passed += 1
		print(f"✓ PASS: {test_name}")
		test_results.append({"name": test_name, "status": "PASS"})
	else:
		tests_failed += 1
		print(f"✗ FAIL: {test_name}")
		test_results.append({"name": test_name, "status": "FAIL"})

func assert_eq(value, expected, test_name: String) -> void:
	if value == expected:
		tests_passed += 1
		print(f"✓ PASS: {test_name} ({value} == {expected})")
		test_results.append({"name": test_name, "status": "PASS"})
	else:
		tests_failed += 1
		print(f"✗ FAIL: {test_name} ({value} != {expected})")
		test_results.append({"name": test_name, "status": "FAIL"})

func assert_not_null(value, test_name: String) -> void:
	if value != null:
		tests_passed += 1
		print(f"✓ PASS: {test_name}")
		test_results.append({"name": test_name, "status": "PASS"})
	else:
		tests_failed += 1
		print(f"✗ FAIL: {test_name}")
		test_results.append({"name": test_name, "status": "FAIL"})

func test_game_manager() -> void:
	print("--- GameManager Tests ---")
	
	var gm = GameManager.new()
	assert_not_null(gm, "GameManager instantiation")
	assert_true(gm.game_state != null, "Game state exists")
	assert_true(gm.game_state.has("player_position"), "Player position in state")
	assert_true(gm.game_state.has("armies"), "Armies in state")
	assert_true(gm.game_state.has("skills"), "Skills in state")
	
	gm.free()
	print()

func test_character_system() -> void:
	print("--- Character System Tests ---")
	
	assert_true(FileAccess.file_exists("res://scripts/character.gd"), "Character script exists")
	assert_true(FileAccess.file_exists("res://scripts/attack_visualizer.gd"), "AttackVisualizer exists")
	assert_true(FileAccess.file_exists("res://scripts/block_visualizer.gd"), "BlockVisualizer exists")
	assert_true(FileAccess.file_exists("res://scripts/damage_indicator.gd"), "DamageIndicator exists")
	
	print()

func test_army_system() -> void:
	print("--- Army System Tests ---")
	
	assert_true(FileAccess.file_exists("res://scripts/army.gd"), "Army script exists")
	assert_true(FileAccess.file_exists("res://scripts/army_command_system.gd"), "ArmyCommandSystem exists")
	assert_true(FileAccess.file_exists("res://scripts/enemy_ai.gd"), "EnemyAI exists")
	
	print()

func test_combat_system() -> void:
	print("--- Combat System Tests ---")
	
	assert_true(FileAccess.file_exists("res://scripts/character.gd"), "Combat character exists")
	assert_true(FileAccess.file_exists("res://scripts/attack_visualizer.gd"), "AttackVisualizer exists")
	assert_true(FileAccess.file_exists("res://scripts/block_visualizer.gd"), "BlockVisualizer exists")
	
	print()

func test_information_system() -> void:
	print("--- Information System Tests ---")
	
	assert_true(FileAccess.file_exists("res://scripts/enhanced_scout.gd"), "EnhancedScout exists")
	assert_true(FileAccess.file_exists("res://scripts/information_display.gd"), "InformationDisplay exists")
	assert_true(FileAccess.file_exists("res://scripts/scout_deployment_ui.gd"), "ScoutDeploymentUI exists")
	
	print()

func test_fog_of_war() -> void:
	print("--- Fog of War Tests ---")
	
	assert_true(FileAccess.file_exists("res://scripts/fog_of_war_visualizer.gd"), "FogOfWarVisualizer exists")
	
	var fog = FogOfWarVisualizer.new()
	assert_not_null(fog, "FogOfWarVisualizer instantiation")
	assert_true(fog.map_size.x == 50 and fog.map_size.y == 50, "Map size is 50x50")
	
	fog.free()
	print()

func test_meeting_system() -> void:
	print("--- Meeting System Tests ---")
	
	assert_true(FileAccess.file_exists("res://scripts/meeting.gd"), "Meeting script exists")
	
	var meeting = Meeting.new()
	assert_not_null(meeting, "Meeting instantiation")
	assert_eq(meeting.meeting_timer, 30.0, "Meeting timer starts at 30 seconds")
	
	meeting.free()
	print()

func test_skill_system() -> void:
	print("--- Skill System Tests ---")
	
	assert_true(FileAccess.file_exists("res://scripts/skill_manager.gd"), "SkillManager exists")
	assert_true(FileAccess.file_exists("res://scripts/active_skill_system.gd"), "ActiveSkillSystem exists")
	
	var skill_mgr = SkillManager.new()
	assert_not_null(skill_mgr, "SkillManager instantiation")
	assert_true(skill_mgr.skills.has("tactical_insight"), "Tactical Insight skill exists")
	assert_true(skill_mgr.skills.has("charisma"), "Charisma skill exists")
	
	skill_mgr.free()
	print()

func test_enemy_ai() -> void:
	print("--- Enemy AI Tests ---")
	
	assert_true(FileAccess.file_exists("res://scripts/enemy_ai.gd"), "EnemyAI script exists")
	
	var ai = EnemyAI.new()
	assert_not_null(ai, "EnemyAI instantiation")
	assert_eq(ai.decision_interval, 5.0, "AI decision interval is 5 seconds")
	assert_eq(ai.AGGRESSIVE_CHANCE, 0.4, "AI aggressive chance is 0.4")
	assert_eq(ai.MOVE_CHANCE, 0.6, "AI move chance is 0.6")
	
	ai.free()
	print()

func test_assets() -> void:
	print("--- Assets Tests ---")
	
	var tile_files = ["plains.png", "forest_01.png", "forest_02.png", "mountains_01.png", "mountains_02.png", "river.png"]
	for tile in tile_files:
		assert_true(FileAccess.file_exists("res://assets/tiles/" + tile), "Tile exists: " + tile)
	
	var sprite_files = ["shogun_blue_n_01.png", "infantry_red_e_02.png", "cavalry_blue_s_01.png"]
	for sprite in sprite_files:
		assert_true(FileAccess.file_exists("res://assets/sprites/" + sprite), "Sprite exists: " + sprite)
	
	var ui_files = ["perch_interface.png", "health_bar.png", "mana_bar.png"]
	for ui_file in ui_files:
		assert_true(FileAccess.file_exists("res://assets/ui/" + ui_file), "UI exists: " + ui_file)
	
	var bg_files = ["menu.png", "combat.png", "meeting.png"]
	for bg in bg_files:
		assert_true(FileAccess.file_exists("res://assets/backgrounds/" + bg), "Background exists: " + bg)
	
	print()

func print_results() -> void:
	print()
	print("=" * 60)
	print("INTEGRATION TEST RESULTS")
	print("=" * 60)
	
	for result in test_results:
		var status = "✓ PASS" if result.status == "PASS" else "✗ FAIL"
		print(f"{status}: {result.name}")
	
	print()
	print("=" * 60)
	
	if tests_failed == 0:
		print("ALL TESTS PASSED ✓")
		print("Game is ready for Step 9: Final Documentation")
	else:
		print(f"{tests_failed} TESTS FAILED")
		print("Fix issues before proceeding to Step 9")
	
	print("=" * 60)

func quit_with_code() -> void:
	get_tree().quit(tests_failed)
