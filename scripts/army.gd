extends Node2D

class_name Army

var army_id: int
var faction_id: int
var unit_count: int
var unit_type: String
var morale: int
var supplies: int
var is_selected: bool = false
var path: Array = []
var current_path_index: int = 0
var is_moving: bool = false

var sprite: Sprite2D
var selection_indicator: Sprite2D
var collision: CollisionShape2D

signal army_selected(army: Army)
signal army_moved(army: Army)

func _ready() -> void:
    setup_sprite()
    setup_collision()
    setup_selection_indicator()

func setup_sprite() -> void:
    sprite = Sprite2D.new()
    sprite.texture = create_placeholder_texture(Color.BLUE)

    match faction_id:
        0:
            sprite.modulate = Color.BLUE
        1:
            sprite.modulate = Color.RED
        _:
            sprite.modulate = Color.WHITE

    sprite.scale = Vector2(0.8, 0.8)
    add_child(sprite)

func setup_collision() -> void:
    collision = CollisionShape2D.new()
    var shape = RectangleShape2D.new()
    shape.size = Vector2(30, 30)
    collision.shape = shape
    collision.collision_layer = 2
    collision.collision_mask = 1
    add_child(collision)

func setup_selection_indicator() -> void:
    selection_indicator = Sprite2D.new()
    selection_indicator.texture = create_placeholder_texture(Color.GOLD)
    selection_indicator.scale = Vector2(1.0, 1.0)
    selection_indicator.visible = false
    add_child(selection_indicator)

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed:
        if event.button_index == MOUSE_BUTTON_LEFT:
            if is_mouse_over():
                select()
        elif event.button_index == MOUSE_BUTTON_RIGHT and is_selected:
            set_path(get_global_mouse_position())

func is_mouse_over() -> bool:
    var mouse_pos = get_global_mouse_position()
    return mouse_pos.distance_to(global_position) < 20

func select() -> void:
    is_selected = true
    selection_indicator.visible = true
    army_selected.emit(self)

func deselect() -> void:
    is_selected = false
    selection_indicator.visible = false

func set_path(destination: Vector2) -> void:
    path = calculate_path(global_position, destination)
    current_path_index = 0
    is_moving = true
    start_movement()

func calculate_path(start: Vector2, end: Vector2) -> Array:
    var path_array = []
    var current = start
    var distance = start.distance_to(end)
    var steps = int(distance / 32)
    
    for i in range(steps + 1):
        var t = float(i) / steps
        var pos = start.lerp(end, t)
        path_array.append(pos)
    
    return path_array

func start_movement() -> void:
    set_process(true)

func _process(delta: float) -> void:
    if is_moving and path.size() > 0:
        move_along_path(delta)

func move_along_path(delta: float) -> void:
    if current_path_index >= path.size():
        is_moving = false
        set_process(false)
        army_moved.emit(self)
        return
    
    var target = path[current_path_index]
    var direction = (target - global_position).normalized()
    var speed = get_movement_speed()
    
    global_position += direction * speed * delta
    
    if global_position.distance_to(target) < 5:
        current_path_index += 1

func get_movement_speed() -> float:
    var base_speed = 16.0
    
    match unit_type:
        "infantry":
            return base_speed
        "cavalry":
            return base_speed * 1.5
        "archers":
            return base_speed * 0.8
    
    return base_speed

func get_combat_power() -> float:
    var morale_modifier = float(morale) / 100.0
    return float(unit_count) * morale_modifier

func take_damage(damage: int) -> void:
    var losses = int(damage / 10)
    unit_count = max(0, unit_count - losses)
    
    if unit_count <= 0:
        destroy()

func destroy() -> void:
    GameManager.game_state["armies"].erase(army_id)
    queue_free()

func get_data() -> Dictionary:
    return {
        "army_id": army_id,
        "faction_id": faction_id,
        "unit_count": unit_count,
        "unit_type": unit_type,
        "morale": morale,
        "supplies": supplies,
        "position": position
    }

func create_placeholder_texture(color: Color, size: Vector2i = Vector2i(32, 32)) -> ImageTexture:
    var image = Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
    image.fill(color)
    var texture = ImageTexture.new()
    texture.set_image(image)
    return texture
