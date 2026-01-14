extends GutTest

var active_skill_system: ActiveSkillSystem

func before_each() -> void:
    active_skill_system = ActiveSkillSystem.new()
    add_child_autofree(active_skill_system)

func test_skill_initialization() -> void:
    var skills = active_skill_system.get_all_skills()
    assert_eq(skills.size(), 2, "Should have 2 skills")
    assert_eq(skills[0].get("name", ""), "Tactical Insight", "First skill should be Tactical Insight")
    assert_eq(skills[1].get("name", ""), "Charisma", "Second skill should be Charisma")

func test_mana_system() -> void:
    assert_eq(active_skill_system.get_available_mana(), 100, "Should start with 100 mana")

func test_skill_cooldown_initial() -> void:
    assert_eq(active_skill_system.is_on_cooldown("Tactical Insight"), false, "Skills should not be on cooldown initially")

func test_use_tactical_insight() -> void:
    var initial_mana = active_skill_system.get_available_mana()
    active_skill_system.use_skill("Tactical Insight")
    
    var final_mana = active_skill_system.get_available_mana()
    assert_eq(final_mana, initial_mana - 5, "Should cost 5 mana")
    assert_true(active_skill_system.is_on_cooldown("Tactical Insight"), "Should be on cooldown")

func test_use_charisma() -> void:
    var initial_mana = active_skill_system.get_available_mana()
    active_skill_system.use_skill("Charisma")
    
    var final_mana = active_skill_system.get_available_mana()
    assert_eq(final_mana, initial_mana - 10, "Should cost 10 mana")
    assert_true(active_skill_system.is_on_cooldown("Charisma"), "Should be on cooldown")

func test_insufficient_mana() -> void:
    active_skill_system.apply_mana_cost(95)
    active_skill_system.use_skill("Tactical Insight")
    
    var mana_after = active_skill_system.get_available_mana()
    assert_eq(mana_after, 0, "Should have 0 mana")
    assert_eq(active_skill_system.get_available_mana(), 0, "Should not have enough mana")

func test_cooldown_duration() -> void:
    active_skill_system.use_skill("Tactical Insight")
    var cooldown = active_skill_system.get_cooldown_remaining("Tactical Insight")
    assert_eq(cooldown, 5.0, "Cooldown should be 5 seconds")

func test_mana_regen() -> void:
    active_skill_system.apply_mana_cost(20)
    active_skill_system.regen_mana(0.0)
    
    var mana = active_skill_system.get_available_mana()
    assert_true(mana > 20, "Mana should have regenerated")

func test_mana_regen_amount() -> void:
    active_skill_system.apply_mana_cost(50)
    await wait_seconds(1.0)
    
    var mana_after = active_skill_system.get_available_mana()
    assert_eq(mana_after, 55, "Should have 55 mana after 1 second")

func test_skill_cooldown_ended() -> void:
    active_skill_system.use_skill("Charisma")
    await wait_seconds(15.1)
    
    assert_false(active_skill_system.is_on_cooldown("Charisma"), "Cooldown should end after 15 seconds")

func test_multiple_skill_usage() -> void:
    active_skill_system.apply_mana_cost(80)
    
    active_skill_system.use_skill("Tactical Insight")
    assert_true(active_skill_system.is_on_cooldown("Tactical Insight"), "First skill on cooldown")
    
    active_skill_system.use_skill("Charisma")
    assert_true(active_skill_system.is_on_cooldown("Charisma"), "Second skill on cooldown")

func test_enemy_reveal() -> void:
    GameManager.game_state["revealed_enemies"] = []
    active_skill_system.use_skill("Tactical Insight")
    
    var enemies = GameManager.game_state.get("revealed_enemies", [])
    assert_true(enemies.size() > 0, "Should reveal enemies")

func test_charisma_boost_application() -> void:
    var armies = GameManager.game_state["armies"]
    GameManager.game_state["charisma_bonus"] = 0.0
    
    active_skill_system.use_skill("Charisma")
    
    for army in armies:
        if army.faction_id == 0:
            var initial_morale = army.get("morale", 100)
            var boosted_morale = army.get("morale", 100)
            assert_true(boosted_morale > initial_morale, "Morale should increase")

func test_add_mana() -> void:
    var initial_mana = active_skill_system.get_available_mana()
    active_skill_system.add_mana(50)
    
    assert_eq(active_skill_system.get_available_mana(), initial_mana + 50, "Mana should increase by 50")
    assert_eq(active_skill_system.get_available_mana(), 150, "Max mana should be 150")

func test_mana_clamp() -> void:
    active_skill_system.add_mana(200)
    
    var mana = active_skill_system.get_available_mana()
    assert_eq(mana, 150, "Mana should clamp to max 150")

func test_skill_ui_button_states() -> void:
    assert_false(active_skill_system.is_on_cooldown("Tactical Insight"), "Should have skill button available")
    assert_false(active_skill_system.is_on_cooldown("Charisma"), "Should have skill button available")

func test_skill_cost_validation() -> void:
    assert_eq(active_skill_system.get_skill_by_name("Tactical Insight").get("cost", 0), 5.0, "Tactical Insight should cost 5 mana")
    assert_eq(active_skill_system.get_skill_by_name("Charisma").get("cost", 0), 10.0, "Charisma should cost 10 mana")

func test_enemy_count_tracking() -> void:
    GameManager.game_state["revealed_enemies"] = []
    active_skill_system.use_skill("Tactical Insight")
    
    assert_eq(active_skill_system.get_enemy_count(), 1, "Should track 1 revealed enemy")

func test_mana_progress_update() -> void:
    var initial_mana = active_skill_system.get_available_mana()
    active_skill_system.apply_mana_cost(30)
    active_skill_system.regen_mana(0.0)
    active_skill_system.regen_mana(0.0)
    
    var mana = active_skill_system.get_available_mana()
    assert_true(mana > initial_mana, "Mana should increase over time")

func test_skill_activation_order() -> void:
    active_skill_system.apply_mana_cost(100)
    
    active_skill_system.use_skill("Tactical Insight")
    var first_cooldown = active_skill_system.is_on_cooldown("Tactical Insight")
    
    active_skill_system.use_skill("Charisma")
    var second_cooldown = active_skill_system.is_on_cooldown("Charisma")
    
    assert_true(first_cooldown and second_cooldown, "Both skills should be on cooldown")
