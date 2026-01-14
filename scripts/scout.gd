extends Node2D

class_name Scout

var scout_id: int
var position: Vector2
var is_active: bool = false
var information_accuracy: float = 0.7
var retrieval_time: float = 10.0
var current_retrieval_time: float = 0.0
var is_retrieving: bool = false

var sprite: Sprite2D

signal information_retrieved(info: Dictionary)

func _ready() -> void:
    setup_sprite()

func setup_sprite() -> void:
    sprite = Sprite2D.new()
    sprite.texture = create_placeholder_texture(Color.GREEN)
    sprite.scale = Vector2(0.5, 0.5)
    add_child(sprite)

func create_placeholder_texture(color: Color, size: Vector2i = Vector2i(32, 32)) -> ImageTexture:
    var image = Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
    image.fill(color)
    var texture = ImageTexture.new()
    texture.set_image(image)
    return texture

func deploy(scout_position: Vector2) -> void:
    position = scout_position
    is_active = true
    is_retrieving = true
    current_retrieval_time = 0.0
    set_process(true)
    
    GameManager.log_event("scout_deploy", {
        "scout_id": scout_id,
        "position": position
    })

func _process(delta: float) -> void:
    if is_retrieving:
        current_retrieval_time += delta
        if current_retrieval_time >= retrieval_time:
            retrieve_information()

func retrieve_information() -> void:
    is_retrieving = false
    
    var accuracy = GameManager.get_information_accuracy()
    var information = {
        "info_id": scout_id,
        "info_type": "troop_positions",
        "data": gather_troop_positions(),
        "accuracy": accuracy,
        "source": "scout",
        "timestamp": Time.get_unix_time_from_system(),
        "is_verified": randf() < accuracy
    }
    
    GameManager.log_event("information_retrieved", information)
    information_retrieved.emit(information)
    
    GameManager.reveal_fog_of_war(position / 32, 8)

func gather_troop_positions() -> Dictionary:
    var troop_positions = {}
    var armies = GameManager.game_state["armies"]
    
    for army in armies:
        var army_data = army.get_data() if army.has_method("get_data") else army
        if army_data["faction_id"] != 0:
            troop_positions[str(army_data["army_id"])] = {
                "position": army_data["position"],
                "unit_count": army_data["unit_count"],
                "unit_type": army_data["unit_type"],
                "uncertainty_radius": int((1.0 - information_accuracy) * 50)
            }
    
    return troop_positions

func calculate_retrieval_time(target_position: Vector2) -> float:
    var base_time = 10.0
    var distance = position.distance_to(target_position)
    var tiles = int(distance / 32.0)
    
    var distance_multiplier = 1.0
    if tiles <= 10:
        distance_multiplier = 1.0
    elif tiles <= 25:
        distance_multiplier = 2.5
    else:
        distance_multiplier = 5.0
    
    return base_time * distance_multiplier

func recall() -> void:
    is_active = false
    is_retrieving = false
    set_process(false)
    GameManager.log_event("scout_recall", {"scout_id": scout_id})
