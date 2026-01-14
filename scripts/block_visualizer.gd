extends Node2D

class_name BlockVisualizer

var block_direction: int = 0
var is_blocking: bool = false
var block_sprite: Sprite2D
var perfect_parry_window: float = 0.1
var partial_block_window: float = 0.3
var block_start_time: float = 0.0
var is_player: bool = true

signal parry_activated
signal block_hit(block_type: String)

func _ready() -> void:
    create_block_sprite()
    visible = false

func create_block_sprite() -> void:
    block_sprite = Sprite2D.new()
    block_sprite.texture = create_block_texture()
    block_sprite.z_index = 60
    block_sprite.modulate = Color(1.0, 1.0, 1.0, 0.0)
    add_child(block_sprite)

func create_block_texture() -> ImageTexture:
    var size = Vector2i(48, 48)
    var image = Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
    image.fill(Color(0, 0, 0, 0))
    
    var center = Vector2(24, 24)
    var color = Color.CYAN if is_player else Color.ORANGE
    
    var thickness = 4
    
    for y in range(size.y):
        for x in range(size.x):
            var pixel = Vector2(x, y)
            var dist = pixel.distance_to(center)
            
            if dist >= 18 and dist <= 22:
                var angle = (pixel - center).angle()
                var dir_angle = get_direction_angle(block_direction)
                var angle_diff = abs(angle - dir_angle)
                
                if angle_diff < PI / 6:
                    image.set_pixel(x, y, color)
    
    var texture = ImageTexture.new()
    texture.set_image(image)
    return texture

func get_direction_angle(direction: int) -> float:
    match direction:
        0:
            return -PI / 2
        1:
            return 0.0
        2:
            return PI / 2
        3:
            return -PI
        _:
            return 0.0

func start_block(direction: int) -> void:
    block_direction = direction
    is_blocking = true
    block_start_time = Time.get_unix_time_from_system()
    visible = true
    
    update_block_rotation()
    update_block_visual()

func stop_block() -> void:
    is_blocking = false
    visible = false

func _process(delta: float) -> void:
    if not is_blocking:
        return
    
    update_block_visual()

func update_block_rotation() -> void:
    match block_direction:
        0:
            rotation_degrees = 0
        1:
            rotation_degrees = 90
        2:
            rotation_degrees = 180
        3:
            rotation_degrees = 270

func update_block_visual() -> void:
    if not block_sprite:
        return
    
    var time_since_start = Time.get_unix_time_from_system() - block_start_time
    var alpha: float = 0.6
    
    if time_since_start < perfect_parry_window:
        alpha = 1.0
        block_sprite.modulate = Color.GOLD
    elif time_since_start < partial_block_window:
        alpha = 0.8
        block_sprite.modulate = Color.CYAN if is_player else Color.ORANGE
    else:
        alpha = 0.4
        block_sprite.modulate = Color.GRAY
    
    block_sprite.modulate.a = alpha

func check_block(attack_direction: int, attack_time: float) -> String:
    if not is_blocking:
        return "none"
    
    var time_since_block_start = Time.get_unix_time_from_system() - block_start_time
    
    var direction_match = (block_direction == attack_direction)
    
    if direction_match and time_since_block_start <= perfect_parry_window:
        parry_activated.emit()
        block_hit.emit("perfect_parry")
        return "perfect_parry"
    elif direction_match and time_since_block_start <= partial_block_window:
        block_hit.emit("partial_block")
        return "partial_block"
    else:
        block_hit.emit("failed_block")
        return "failed_block"

func get_damage_reduction(block_type: String) -> float:
    match block_type:
        "perfect_parry":
            return 1.0  # 100% reduction
        "partial_block":
            return 0.5  # 50% reduction
        "failed_block":
            return 0.0  # 0% reduction
        _:
            return 0.0
