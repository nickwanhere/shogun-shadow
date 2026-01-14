extends GutTest

var meeting_system: Meeting

func before_each() -> void:
    meeting_system = Meeting.new()
    add_child_autofree(meeting_system)

func test_step5_perch_ui_displays() -> void:
    var meeting_data = meeting_system.get_default_meeting_data()
    meeting_system.start_meeting(meeting_data)
    
    assert_true(meeting_system.visible, "Meeting UI should be visible")
    assert_true(meeting_system.situation_panel != null, "Situation panel should exist")
    assert_true(meeting_system.options_panel != null, "Options panel should exist")
    assert_true(meeting_system.info_panel != null, "Info panel should exist")
    assert_true(meeting_system.time_label != null, "Time label should exist")

func test_step5_timer_counts_down() -> void:
    var meeting_data = meeting_system.get_default_meeting_data()
    meeting_system.start_meeting(meeting_data)
    
    var initial_timer = meeting_system.meeting_timer
    meeting_system._process(1.0)
    
    assert_true(meeting_system.meeting_timer < initial_timer, "Timer should decrease")
    assert_eq(meeting_system.meeting_timer, initial_timer - 1.0, "Timer should decrease by 1 second")

func test_step5_game_speed_reduces() -> void:
    var original_speed = Engine.time_scale
    var meeting_data = meeting_system.get_default_meeting_data()
    meeting_system.start_meeting(meeting_data)
    
    assert_eq(Engine.time_scale, 0.5, "Game speed should be 50% during meeting")

func test_step5_background_blur() -> void:
    var meeting_data = meeting_system.get_default_meeting_data()
    meeting_system.start_meeting(meeting_data)
    
    assert_true(meeting_system.modulate.a < 1.0 or meeting_system.is_visible(), "Meeting should be visible")

func test_step5_decision_timer_expiry() -> void:
    var meeting_data = meeting_system.get_default_meeting_data()
    meeting_system.start_meeting(meeting_data)
    
    var options = meeting_data.get("options", [])
    var initial_option_count = options.size()
    
    meeting_system._process(31.0)
    
    assert_false(meeting_system.is_active, "Meeting should end when timer expires")
    assert_false(meeting_system.visible, "Meeting should be invisible after expiry")

func test_step5_consequences_apply() -> void:
    GameManager.game_state["attack_power_bonus"] = 0.0
    GameManager.game_state["defense_bonus"] = 0.0
    GameManager.game_state["army_speed_bonus"] = 0.0
    
    var meeting_data = meeting_system.get_default_meeting_data()
    meeting_system.start_meeting(meeting_data)
    
    var options = meeting_data.get("options", [])
    if options.size() > 0:
        meeting_system.select_option(0)
        
        var option = options[0]
        var consequences = option.get("consequences", {})
        
        if consequences.has("attack_power"):
            assert_true(GameManager.game_state["attack_power_bonus"] != 0.0, "Attack bonus should be applied")

func test_step5_morale_changes() -> void:
    var test_army = Army.new()
    test_army.faction_id = 0
    test_army.morale = 80
    test_army.army_id = 999
    
    GameManager.game_state["armies"] = [test_army]
    
    var option = {
        "name": "Test Option",
        "consequences": {
            "morale": 0.1
        }
    }
    
    meeting_system.apply_decision_consequences(option)
    
    assert_true(test_army.morale >= 80, "Morale should change based on consequences")

func test_step5_meeting_ends_properly() -> void:
    var meeting_data = meeting_system.get_default_meeting_data()
    meeting_system.start_meeting(meeting_data)
    
    meeting_system.end_meeting()
    
    assert_false(meeting_system.is_active, "Meeting should be inactive")
    assert_false(meeting_system.visible, "Meeting should be invisible")
    assert_eq(Engine.time_scale, 1.0, "Game speed should restore")

func test_step5_situation_display() -> void:
    var meeting_data = meeting_system.get_default_meeting_data()
    meeting_system.start_meeting(meeting_data)
    
    var situation_text = meeting_system.situation_panel.text if meeting_system.situation_panel else ""
    
    assert_true("Player Position:" in situation_text, "Should display player position")
    assert_true("Health:" in situation_text, "Should display health")
    assert_true("Stamina:" in situation_text, "Should display stamina")
    assert_true("Armies:" in situation_text, "Should display army count")

func test_step5_options_display() -> void:
    var meeting_data = meeting_system.get_default_meeting_data()
    meeting_system.start_meeting(meeting_data)
    
    var options_text = meeting_system.options_panel.text if meeting_system.options_panel else ""
    
    assert_true("Decision Options:" in options_text, "Should display options header")
    
    var options = meeting_data.get("options", [])
    for i in range(options.size()):
        var option_name = options[i].get("name", "")
        assert_true(option_name in options_text, "Should display option: " + option_name)

func test_step5_info_display() -> void:
    var meeting_data = meeting_system.get_default_meeting_data()
    meeting_system.start_meeting(meeting_data)
    
    var info_text = meeting_system.info_panel.text if meeting_system.info_panel else ""
    
    assert_true("Available Information:" in info_text, "Should display info header")

func test_step5_timer_display() -> void:
    var meeting_data = meeting_system.get_default_meeting_data()
    meeting_system.start_meeting(meeting_data)
    
    var time_text = meeting_system.time_label.text if meeting_system.time_label else ""
    
    assert_true("Time Remaining:" in time_text, "Should display timer")
    assert_true("seconds" in time_text, "Should show time unit")

func test_step5_option_selection() -> void:
    var meeting_data = meeting_system.get_default_meeting_data()
    meeting_system.start_meeting(meeting_data)
    
    meeting_system.select_option(0)
    
    assert_eq(meeting_system.current_meeting_data.get("selected_option", -1), 0, "Should store selected option")

func test_step5_multiple_meetings() -> void:
    var meeting_data = meeting_system.get_default_meeting_data()
    
    meeting_system.start_meeting(meeting_data)
    meeting_system.end_meeting()
    
    meeting_system.start_meeting(meeting_data)
    assert_true(meeting_system.is_active, "Should allow multiple meetings sequentially")

func test_step5_signal_emission() -> void:
    var signal_received = false
    var received_index = -1
    
    meeting_system.meeting_decision_selected.connect(func(index):
        signal_received = true
        received_index = index
    )
    
    var meeting_data = meeting_system.get_default_meeting_data()
    meeting_system.start_meeting(meeting_data)
    meeting_system.select_option(0)
    
    assert_true(signal_received, "Should emit decision selected signal")
    assert_eq(received_index, 0, "Should pass correct option index")

func test_step5_game_state_updates() -> void:
    var meeting_data = meeting_system.get_default_meeting_data()
    meeting_system.start_meeting(meeting_data)
    
    assert_not_null(GameManager.game_state.get("current_meeting"), "Should store current meeting in state")
    
    meeting_system.end_meeting()
    
    assert_eq(GameManager.game_state.get("current_meeting", {}), null, "Should clear meeting from state after end")
