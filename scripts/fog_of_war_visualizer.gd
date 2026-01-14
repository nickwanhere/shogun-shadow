extends Node2D

class_name FogOfWarVisualizer

var tile_size: Vector2i = Vector2i(32, 32)
var fog_layer: TileMapLayer
var overlay_sprite: Sprite2D
var fog_texture: ImageTexture
var fog_image: Image
var map_size: Vector2i = Vector2i(50, 50)

var fog_data: Array = []
var visibility_radius: int = 5
var exploration_data: Dictionary = {}

signal fog_updated(visible_tiles: Array)
signal tile_revealed(position: Vector2i)

func _ready() -> void:
    initialize_fog_system()
    create_fog_visuals()

func initialize_fog_system() -> void:
    fog_data = []
    for x in range(map_size.x):
        fog_data.append([])
        for y in range(map_size.y):
            fog_data[x].append({
                "visible": false,
                "explored": false,
                "last_seen": 0.0
            })
            exploration_data[Vector2i(x, y)] = 0.0

func create_fog_visuals() -> void:
    fog_image = Image.create(map_size.x * tile_size.x, map_size.y * tile_size.y, false, Image.FORMAT_RGBA8)
    fog_image.fill(Color(0, 0, 0, 0.8))
    fog_texture = ImageTexture.new()
    fog_texture.set_image(fog_image)
    
    overlay_sprite = Sprite2D.new()
    overlay_sprite.texture = fog_texture
    overlay_sprite.z_index = 10
    add_child(overlay_sprite)
    
    update_fog_visuals()

func update_fog_visuals() -> void:
    var full_size = Vector2i(map_size.x * tile_size.x, map_size.y * tile_size.y)
    
    for x in range(map_size.x):
        for y in range(map_size.y):
            var tile_pos = Vector2i(x, y)
            var fog_info = fog_data[x][y]
            var tile_fog = Color(0, 0, 0, 1.0)
            
            if fog_info["visible"]:
                tile_fog = Color(0, 0, 0, 0.0)
            elif fog_info["explored"]:
                var time_since_seen = Time.get_unix_time_from_system() - fog_info["last_seen"]
                var fade = min(time_since_seen / 60.0, 0.5)
                tile_fog = Color(0, 0, 0, 0.3 + fade)
            
            draw_fog_tile(tile_pos, tile_fog)
    
    fog_texture.set_image(fog_image)

func draw_fog_tile(tile_pos: Vector2i, fog_color: Color) -> void:
    var pixel_x = tile_pos.x * tile_size.x
    var pixel_y = tile_pos.y * tile_size.y
    
    for y in range(tile_size.y):
        for x in range(tile_size.x):
            fog_image.set_pixel(pixel_x + x, pixel_y + y, fog_color)

func reveal_area(center: Vector2i, radius: int) -> void:
    var revealed_tiles = []
    
    for x in range(center.x - radius, center.x + radius + 1):
        for y in range(center.y - radius, center.y + radius + 1):
            if x < 0 or x >= map_size.x or y < 0 or y >= map_size.y:
                continue
            
            var distance = int(sqrt(float((x - center.x) * (x - center.x) + (y - center.y) * (y - center.y)))
            
            if distance <= radius:
                if not fog_data[x][y]["visible"]:
                    tile_revealed.emit(Vector2i(x, y))
                
                fog_data[x][y]["visible"] = true
                fog_data[x][y]["explored"] = true
                fog_data[x][y]["last_seen"] = Time.get_unix_time_from_system()
                revealed_tiles.append(Vector2i(x, y))
    
    update_fog_visuals()
    fog_updated.emit(revealed_tiles)

func hide_area(center: Vector2i, radius: int) -> void:
    for x in range(center.x - radius, center.x + radius + 1):
        for y in range(center.y - radius, center.y + radius + 1):
            if x < 0 or x >= map_size.x or y < 0 or y >= map_size.y:
                continue
            
            fog_data[x][y]["visible"] = false
    
    update_fog_visuals()

func is_visible(tile_pos: Vector2i) -> bool:
    if tile_pos.x < 0 or tile_pos.x >= map_size.x or tile_pos.y < 0 or tile_pos.y >= map_size.y:
        return false
    
    return fog_data[tile_pos.x][tile_pos.y]["visible"]

func is_explored(tile_pos: Vector2i) -> bool:
    if tile_pos.x < 0 or tile_pos.x >= map_size.x or tile_pos.y < 0 or tile_pos.y >= map_size.y:
        return false
    
    return fog_data[tile_pos.x][tile_pos.y]["explored"]

func get_visible_tiles() -> Array:
    var visible = []
    for x in range(map_size.x):
        for y in range(map_size.y):
            if fog_data[x][y]["visible"]:
                visible.append(Vector2i(x, y))
    return visible

func get_exploration_percentage() -> float:
    var explored_count = 0
    var total_tiles = map_size.x * map_size.y
    
    for x in range(map_size.x):
        for y in range(map_size.y):
            if fog_data[x][y]["explored"]:
                explored_count += 1
    
    return float(explored_count) / float(total_tiles) * 100.0
