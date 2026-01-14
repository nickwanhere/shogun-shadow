extends CharacterBody2D

const MAX_HEALTH: int = 100
const MAX_STAMINA: int = 100
const BASE_DAMAGE: int = 10
const STAMINA_ATTACK_COST: int = 15
const STAMINA_BLOCK_COST: int = 5
const STAMINA_REGEN: int = 10
const PERFECT_PARRY_BONUS: int = 5

var health: int = MAX_HEALTH
var stamina: int = MAX_STAMINA
var attack_direction: int = 0
var is_blocking: bool = false
var is_attacking: bool = false
var attack_time: float = 0.0
var block_start_time: float = 0.0

var sprite: Sprite2D
var collision: CollisionShape2D

signal damage_taken(damage: int, position: Vector2)
signal attacked(direction: int)

func _ready() -> void:
    sprite = Sprite2D.new()
    sprite.texture = create_placeholder_texture(Color.BLUE)
    sprite.scale = Vector2(0.9, 0.9)
    add_child(sprite)

    collision = CollisionShape2D.new()
    var shape = RectangleShape2D.new()
    shape.size = Vector2(28, 28)
    collision.shape = shape
    add_child(collision)

func create_placeholder_texture(color: Color, size: Vector2i = Vector2i(32, 32)) -> ImageTexture:
    var image = Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
    image.fill(color)
    var texture = ImageTexture.new()
    texture.set_image(image)
    return texture

func _process(delta: float) -> void:
    regenerate_stamina(delta)
    
    if is_attacking:
        attack_time += delta
        if attack_time >= 0.9:
            is_attacking = false
            attack_time = 0.0

func regenerate_stamina(delta: float) -> void:
    if not is_attacking and not is_blocking:
        stamina = min(stamina + int(STAMINA_REGEN * delta), MAX_STAMINA)
    GameManager.update_player_stamina(stamina)

func take_damage(damage: int, attack_dir: int = -1) -> void:
    var final_damage = damage
    var block_type = "none"
    
    if is_blocking and attack_dir >= 0:
        block_type = check_block_timing(attack_dir)
        final_damage = calculate_blocked_damage(damage, block_type)
        
        if block_type != "none":
            stamina -= STAMINA_BLOCK_COST
            if stamina < 0:
                is_blocking = false
    
    health -= final_damage
    GameManager.log_event("damage", {
        "damage": final_damage,
        "remaining_health": health,
        "block_type": block_type
    })
    
    damage_taken.emit(final_damage, global_position)
    
    if health <= 0:
        die()
    
    GameManager.update_player_health(health)

func check_block_timing(attack_dir: int) -> String:
    if not is_blocking:
        return "none"
    
    var time_since_block = Time.get_unix_time_from_system() - block_start_time
    var direction_match = (attack_direction == attack_dir)
    
    if direction_match and time_since_block <= 0.1:
        return "perfect_parry"
    elif direction_match and time_since_block <= 0.3:
        return "partial_block"
    else:
        return "failed_block"

func calculate_blocked_damage(damage: int, block_type: String) -> int:
    match block_type:
        "perfect_parry":
            return 0
        "partial_block":
            return damage / 2
        "failed_block":
            return damage
        _:
            return damage

func attack() -> void:
    if is_attacking or stamina < STAMINA_ATTACK_COST:
        return
    
    stamina -= STAMINA_ATTACK_COST
    is_attacking = true
    attack_time = 0.0
    
    var damage = calculate_damage()
    apply_attack_damage(damage)
    
    GameManager.log_event("attack", {
        "direction": attack_direction,
        "damage": damage
    })

func calculate_damage() -> int:
    var base_damage = BASE_DAMAGE
    var hit_location = get_hit_location()
    var hit_multiplier = get_hit_multiplier(hit_location)
    
    var charisma_bonus = GameManager.get_skill_effect("charisma")
    base_damage = int(base_damage * (1.0 + charisma_bonus))
    
    return int(base_damage * hit_multiplier)

func apply_attack_damage(damage: int) -> void:
    var enemies = get_enemies_in_range(attack_direction)
    for enemy in enemies:
        enemy.take_damage(damage)

func get_hit_location() -> String:
    var locations = ["head", "body", "legs"]
    var rand_index = randi() % locations.size()
    return locations[rand_index]

func get_hit_multiplier(location: String) -> float:
    match location:
        "head":
            return 1.5
        "body":
            return 1.0
        "legs":
            return 0.8
        _:
            return 1.0

func get_enemies_in_range(direction: int) -> Array:
    var enemies = []
    var attack_vector = Vector2.ZERO
    
    match direction:
        0:
            attack_vector = Vector2(0, -1)
        1:
            attack_vector = Vector2(1, 0)
        2:
            attack_vector = Vector2(0, 1)
        3:
            attack_vector = Vector2(-1, 0)
    
    var attack_pos = position + attack_vector * 32
    var space_state = get_world_2d().direct_space_state
    
    var query = PhysicsPointQueryParameters2D.new()
    query.position = attack_pos
    query.collision_mask = 2
    
    var results = space_state.intersect_point(query)
    for result in results:
        if result.collider.has_method("take_damage"):
            enemies.append(result.collider)
    
    return enemies

func block(should_block: bool) -> void:
    is_blocking = should_block
    if should_block:
        modulate = Color.GRAY
        block_start_time = Time.get_unix_time_from_system()
    else:
        modulate = Color.WHITE

func attack() -> void:
    if is_attacking or stamina < STAMINA_ATTACK_COST:
        return
    
    stamina -= STAMINA_ATTACK_COST
    is_attacking = true
    attack_time = 0.0
    
    attacked.emit(attack_direction)
    
    GameManager.log_event("attack", {
        "direction": attack_direction,
        "damage": calculate_damage()
    })

func die() -> void:
    GameManager.log_event("death", {"position": position})
    queue_free()
