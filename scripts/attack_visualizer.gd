extends Node2D

class_name AttackVisualizer

var attack_direction: int = 0
var attack_type: String = "slash"
var attack_phase: String = "idle"  # idle, windup, attack, recovery
var phase_timer: float = 0.0
var attack_sprite: Sprite2D
var is_player: bool = true

const WINDUP_TIME: float = 0.3
const ATTACK_TIME: float = 0.2
const RECOVERY_TIME: float = 0.4

signal attack_completed
signal damage_dealt(damage: int, position: Vector2)

func _ready() -> void:
    create_attack_sprite()
    visible = false

func create_attack_sprite() -> void:
    attack_sprite = Sprite2D.new()
    attack_sprite.texture = create_attack_texture()
    attack_sprite.z_index = 50
    attack_sprite.modulate = Color(1.0, 1.0, 1.0, 0.0)
    add_child(attack_sprite)

func create_attack_texture() -> ImageTexture:
    var size = Vector2i(64, 64)
    var image = Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
    image.fill(Color(0, 0, 0, 0))
    
    var center = Vector2(32, 32)
    var color = Color.RED if is_player else Color.BLUE
    
    for y in range(size.y):
        for x in range(size.x):
            var pixel = Vector2(x, y)
            var dist = pixel.distance_to(center)
            
            if dist < 30 and dist > 15:
                var angle = (pixel - center).angle()
                var dir_angle = get_direction_angle(attack_direction)
                var angle_diff = abs(angle - dir_angle)
                
                if angle_diff < PI / 4:
                    var alpha = 1.0 - (dist / 30.0)
                    image.set_pixel(x, y, Color(color.r, color.g, color.b, alpha))
    
    var texture = ImageTexture.new()
    texture.set_image(image)
    return texture

func get_direction_angle(direction: int) -> float:
    match direction:
        0:
            return -PI / 2  # North
        1:
            return 0.0        # East
        2:
            return PI / 2   # South
        3:
            return -PI     # West
        _:
            return 0.0

func start_attack(direction: int, type: String = "slash") -> void:
    attack_direction = direction
    attack_type = type
    attack_phase = "windup"
    phase_timer = 0.0
    visible = true
    
    update_attack_rotation()
    update_attack_visual()

func _process(delta: float) -> void:
    if attack_phase == "idle":
        return
    
    phase_timer += delta
    update_attack_visual()
    
    match attack_phase:
        "windup":
            if phase_timer >= WINDUP_TIME:
                attack_phase = "attack"
                phase_timer = 0.0
                trigger_damage()
        "attack":
            if phase_timer >= ATTACK_TIME:
                attack_phase = "recovery"
                phase_timer = 0.0
        "recovery":
            if phase_timer >= RECOVERY_TIME:
                attack_phase = "idle"
                visible = false
                attack_completed.emit()

func update_attack_rotation() -> void:
    match attack_direction:
        0:
            rotation_degrees = 0
        1:
            rotation_degrees = 90
        2:
            rotation_degrees = 180
        3:
            rotation_degrees = 270

func update_attack_visual() -> void:
    if not attack_sprite:
        return
    
    var alpha: float = 0.0
    
    match attack_phase:
        "windup":
            alpha = 0.3 * (phase_timer / WINDUP_TIME)
        "attack":
            alpha = 0.8
        "recovery":
            alpha = 0.8 * (1.0 - (phase_timer / RECOVERY_TIME))
    
    attack_sprite.modulate = Color(1.0, 1.0, 1.0, alpha)

func trigger_damage() -> void:
    var damage = calculate_attack_damage()
    var attack_pos = get_global_position() + get_attack_offset()
    damage_dealt.emit(damage, attack_pos)

func get_attack_offset() -> Vector2:
    var offset = Vector2(32, 0)
    match attack_direction:
        0:
            offset = Vector2(0, -32)
        1:
            offset = Vector2(32, 0)
        2:
            offset = Vector2(0, 32)
        3:
            offset = Vector2(-32, 0)
    return offset

func calculate_attack_damage() -> int:
    var base_damage = 10
    var location = get_hit_location()
    var multiplier = get_damage_multiplier(location)
    return int(base_damage * multiplier)

func get_hit_location() -> String:
    var locations = ["head", "body", "legs"]
    return locations[randi() % locations.size()]

func get_damage_multiplier(location: String) -> float:
    match location:
        "head":
            return 1.5
        "body":
            return 1.0
        "legs":
            return 0.8
        _:
            return 1.0
