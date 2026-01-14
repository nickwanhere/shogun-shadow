extends GutTest

var army: Node2D
var script_instance: Army

func before_each() -> void:
    army = Node2D.new()
    script_instance = Army.new()
    army.add_child(script_instance)
    add_child_autofree(army)
    script_instance.army_id = 1
    script_instance.faction_id = 0
    script_instance.unit_count = 100
    script_instance.unit_type = "infantry"
    script_instance.morale = 100
    script_instance.supplies = 100

func test_initial_army_setup() -> void:
    assert_eq(script_instance.unit_count, 100, "Unit count should start at 100")
    assert_eq(script_instance.morale, 100, "Morale should start at 100")
    assert_eq(script_instance.faction_id, 0, "Faction ID should be 0")

func test_select_army() -> void:
    script_instance.select()
    assert_true(script_instance.is_selected, "Army should be selected")
    assert_true(script_instance.selection_indicator.visible, "Selection indicator should be visible")

func test_deselect_army() -> void:
    script_instance.select()
    script_instance.deselect()
    assert_false(script_instance.is_selected, "Army should be deselected")
    assert_false(script_instance.selection_indicator.visible, "Selection indicator should be hidden")

func test_take_damage() -> void:
    script_instance.take_damage(30)
    assert_true(script_instance.unit_count < 100, "Unit count should decrease after damage")
    assert_true(script_instance.unit_count >= 97, "Unit count should decrease appropriately")

func test_army_destruction() -> void:
    script_instance.unit_count = 1
    script_instance.take_damage(100)
    pass

func test_combat_power() -> void:
    script_instance.unit_count = 100
    script_instance.morale = 100
    var power = script_instance.get_combat_power()
    assert_eq(power, 100.0, "Combat power should equal unit count at 100% morale")

func test_combat_power_low_morale() -> void:
    script_instance.unit_count = 100
    script_instance.morale = 50
    var power = script_instance.get_combat_power()
    assert_eq(power, 50.0, "Combat power should be halved at 50% morale")

func test_movement_speed_infantry() -> void:
    script_instance.unit_type = "infantry"
    var speed = script_instance.get_movement_speed()
    assert_eq(speed, 16.0, "Infantry speed should be 16.0")

func test_movement_speed_cavalry() -> void:
    script_instance.unit_type = "cavalry"
    var speed = script_instance.get_movement_speed()
    assert_true(speed > 16.0, "Cavalry should be faster than infantry")

func test_movement_speed_archers() -> void:
    script_instance.unit_type = "archers"
    var speed = script_instance.get_movement_speed()
    assert_true(speed < 16.0, "Archers should be slower than infantry")

func test_get_army_data() -> void:
    var data = script_instance.get_data()
    assert_true(data.has("army_id"), "Army data should contain army_id")
    assert_true(data.has("unit_count"), "Army data should contain unit_count")
    assert_true(data.has("morale"), "Army data should contain morale")
