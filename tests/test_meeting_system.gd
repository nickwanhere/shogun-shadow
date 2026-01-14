extends GutTest

var meeting: Meeting
var default_options: Array

func before_each() -> void:
    meeting = Meeting.new()
    add_child_autofree(meeting)
    default_options = meeting.get_default_meeting_data().get("options", [])

func test_meeting_initialization() -> void:
    assert_false(meeting.is_active, "Meeting should be inactive initially")
    assert_eq(meeting.meeting_timer, 30.0, "Timer should start at 30 seconds")

func test_meeting_start() -> void:
    meeting.start_meeting(meeting.get_default_meeting_data())
    assert_true(meeting.is_active, "Meeting should be active")
    assert_true(meeting.visible, "Meeting should be visible")
    assert_eq(meeting.game_speed_before_meeting, 1.0, "Should save original game speed")

func test_game_speed_reduction() -> void:
    meeting.start_meeting(meeting.get_default_meeting_data())
    assert_eq(Engine.time_scale, 0.5, "Game speed should be 50% during meeting")

func test_meeting_timer_countdown() -> void:
    meeting.start_meeting(meeting.get_default_meeting_data())
    var initial_time = meeting.meeting_timer
    await wait_seconds(1.0)
    assert_true(meeting.meeting_timer < initial_time, "Timer should decrease")

func test_meeting_timer_expiry() -> void:
    meeting.start_meeting(meeting.get_default_meeting_data())
    await wait_seconds(31.0)
    assert_false(meeting.is_active, "Meeting should end after timer expiry")
    assert_eq(meeting.meeting_timer, 0.0, "Timer should be at 0")

func test_option_selection() -> void:
    meeting.start_meeting(meeting.get_default_meeting_data())
    meeting.select_option(0)
    assert_eq(meeting.current_meeting_data.get("selected_option", -1), 0, "Should store selected option index")

func test_consequences_application_attack() -> void:
    GameManager.game_state["attack_power_bonus"] = 0.0
    GameManager.game_state["defense_bonus"] = 0.0
    GameManager.game_state["morale"] = 0.0
    
    var option = {
        "name": "Test Option",
        "consequences": {
            "attack_power": 0.2,
            "defense": -0.1,
            "morale": 0.1
        }
    }
    
    meeting.apply_decision_consequences(option)
    assert_eq(GameManager.game_state["attack_power_bonus"], 0.2, "Should apply attack power bonus")

func test_consequences_application_defense() -> void:
    GameManager.game_state["attack_power_bonus"] = 0.0
    GameManager.game_state["defense_bonus"] = 0.0
    
    var option = {
        "name": "Test Option",
        "consequences": {
            "defense": 0.25
        }
    }
    
    meeting.apply_decision_consequences(option)
    assert_eq(GameManager.game_state["defense_bonus"], 0.25, "Should apply defense bonus")

func test_consequences_application_morale() -> void:
    GameManager.game_state["morale"] = 0.0
    
    var option = {
        "name": "Test Option",
        "consequences": {
            "morale": -0.15
        }
    }
    
    meeting.apply_decision_consequences(option)
    var player_armies = GameManager.game_state.get("armies", [])
    var test_army = null
    
    for army in player_armies:
        if army.faction_id == 0:
            test_army = army
            break
    
    if test_army:
        assert_true(test_army.morale < 80, "Morale should decrease")

func test_game_speed_restoration() -> void:
    meeting.start_meeting(meeting.get_default_meeting_data())
    await wait_seconds(1.0)
    meeting.end_meeting()
    
    assert_false(meeting.is_active, "Meeting should be inactive")
    assert_eq(Engine.time_scale, 1.0, "Game speed should restore to 100%")

func test_meeting_end_cleans_state() -> void:
    meeting.start_meeting(meeting.get_default_meeting_data())
    meeting.end_meeting()
    
    assert_false(meeting.visible, "Meeting should be invisible after end")
    assert_eq(GameManager.game_state.get("current_meeting", null), null, "Current meeting should be cleared")

func test_multiple_meetings() -> void:
    meeting.start_meeting(meeting.get_default_meeting_data())
    meeting.end_meeting()
    
    meeting.start_meeting(meeting.get_default_meeting_data())
    assert_true(meeting.is_active, "Should allow sequential meetings")

func test_meeting_ui_update() -> void:
    meeting.start_meeting(meeting.get_default_meeting_data())
    
    assert_true(meeting.situation_panel is RichTextLabel, "Situation panel should be RichTextLabel")
    assert_true(meeting.info_panel is RichTextLabel, "Info panel should be RichTextLabel")
    assert_true(meeting.options_panel is RichTextLabel, "Options panel should be RichTextLabel")

func test_situation_panel_content() -> void:
    meeting.start_meeting(meeting.get_default_meeting_data())
    await wait_seconds(0.1)
    
    var situation_text = meeting.situation_panel.text if meeting.situation_panel else ""
    assert_true("Player Position:" in situation_text, "Should show player position")
    assert_true("Health:" in situation_text, "Should show health")

func test_info_panel_content() -> void:
    meeting.start_meeting(meeting.get_default_meeting_data())
    await wait_seconds(0.1)
    
    var info_text = meeting.info_panel.text if meeting.info_panel else ""
    assert_true("Available Information:" in info_text, "Should show info header")

func test_options_panel_content() -> void:
    meeting.start_meeting(meeting.get_default_meeting_data())
    await wait_seconds(0.1)
    
    var options_text = meeting.options_panel.text if meeting.options_panel else ""
    assert_true("Decision Options:" in options_text, "Should show options header")

func test_get_default_data() -> void:
    var default_data = meeting.get_default_meeting_data()
    assert_true(default_data.has("type"), "Should have type")
    assert_true(default_data.has("options"), "Should have options")
    assert_eq(default_data.get("type", ""), "tactical", "Type should be tactical")

func test_option_boundary_conditions() -> void:
    meeting.start_meeting(meeting.get_default_meeting_data())
    
    meeting.select_option(-1)
    await wait_seconds(0.1)
    assert_false(meeting.is_queued_for_deletion(), "Invalid option should not end meeting")
    
    meeting.select_option(100)
    await wait_seconds(0.1)
    assert_false(meeting.is_queued_for_deletion(), "Out of bounds option should not end meeting")
