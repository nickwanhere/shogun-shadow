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

func test_initial_health() -> void:
    assert_eq(script_instance.health, 100, "Health should start at 100")

func test_initial_stamina() -> void:
    assert_eq(script_instance.stamina, 100, "Stamina should start at 100")

func test_take_damage() -> void:
    script_instance.take_damage(20)
    assert_eq(script_instance.health, 80, "Health should decrease by damage amount")

func test_block_reduces_damage() -> void:
    script_instance.block(true)
    script_instance.take_damage(20)
    assert_eq(script_instance.health, 90, "Blocking should reduce damage by 50%")

func test_attack_consumes_stamina() -> void:
    script_instance.attack()
    assert_eq(script_instance.stamina, 85, "Attack should consume stamina")

func test_insufficient_stamina_prevents_attack() -> void:
    script_instance.stamina = 10
    var initial_stamina = script_instance.stamina
    script_instance.attack()
    assert_eq(script_instance.stamina, initial_stamina, "Insufficient stamina should prevent attack")

func test_hit_multiplier_head() -> void:
    var multiplier = script_instance.get_hit_multiplier("head")
    assert_eq(multiplier, 1.5, "Head hit multiplier should be 1.5")

func test_hit_multiplier_body() -> void:
    var multiplier = script_instance.get_hit_multiplier("body")
    assert_eq(multiplier, 1.0, "Body hit multiplier should be 1.0")

func test_hit_multiplier_legs() -> void:
    var multiplier = script_instance.get_hit_multiplier("legs")
    assert_eq(multiplier, 0.8, "Legs hit multiplier should be 0.8")

func test_calculate_damage() -> void:
    var damage = script_instance.calculate_damage()
    assert_true(damage >= 8 and damage <= 15, "Damage should be in valid range")

func test_death_on_zero_health() -> void:
    script_instance.take_damage(100)
    assert_true(script_instance.health <= 0, "Character should be dead at zero health")

func test_stamina_regeneration() -> void:
    script_instance.stamina = 50
    script_instance.regenerate_stamina(1.0)
    assert_true(script_instance.stamina > 50, "Stamina should regenerate")
    assert_true(script_instance.stamina <= 100, "Stamina should not exceed max")
