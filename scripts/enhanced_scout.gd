extends Node2D

class_name Scout

var scout_id: int
var is_active: bool = false
var is_deployed: bool = false
var is_retrieving: bool = false
var information_accuracy: float = 0.7
var base_retrieval_time: float = 10.0
var current_retrieval_time: float = 0.0
var retrieval_time: float = 10.0
var deployment_position: Vector2
var scout_level: int = 1
var faction_id: int = 0

var sprite: Sprite2D
var progress_bar: ProgressBar

signal information_retrieved(info: Dictionary)
signal deployment_complete(scout_id: int)
signal recall_complete(scout_id: int)

const DISTANCE_NEAR: float = 10.0
const DISTANCE_MEDIUM: float = 25.0
const DISTANCE_FAR: float = 50.0

const MULTIPLIER_NEAR: float = 1.0
const MULTIPLIER_MEDIUM: float = 2.5
const MULTIPLIER_FAR: float = 5.0

func _ready() -> void:
    setup_sprite()
    setup_progress_bar()
    visible = false

func setup_sprite() -> void:
    sprite = Sprite2D.new()
    sprite.texture = create_placeholder_texture(Color.GREEN)
    sprite.scale = Vector2(0.5, 0.5)
    sprite.z_index = 15
    add_child(sprite)

func setup_progress_bar() -> void:
    progress_bar = ProgressBar.new()
    progress_bar.max_value = retrieval_time
    progress_bar.value = 0.0
    progress_bar.show_percentage = false
    progress_bar.position = Vector2(-10, 25)
    add_child(progress_bar)

func create_placeholder_texture(color: Color, size: Vector2i = Vector2i(32, 32)) -> ImageTexture:
    var image = Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
    image.fill(color)
    var texture = ImageTexture.new()
    texture.set_image(image)
    return texture

func deploy_at(tile_position: Vector2) -> void:
    deployment_position = tile_position
    global_position = tile_position * 32
    is_deployed = true
    is_active = true
    is_retrieving = true
    current_retrieval_time = 0.0
    
    var retrieval_multiplier = calculate_distance_multiplier(tile_position)
    retrieval_time = base_retrieval_time * retrieval_multiplier
    
    visible = true
    progress_bar.max_value = retrieval_time
    
    GameManager.log_event("scout_deploy", {
        "scout_id": scout_id,
        "position": tile_position,
        "retrieval_time": retrieval_time,
        "multiplier": retrieval_multiplier
    })

func calculate_distance_multiplier(target_position: Vector2) -> float:
    var player_pos = GameManager.game_state.get("player_position", Vector2.ZERO)
    var distance = player_pos.distance_to(target_position)
    
    if distance <= DISTANCE_NEAR:
        return MULTIPLIER_NEAR
    elif distance <= DISTANCE_MEDIUM:
        return MULTIPLIER_MEDIUM
    else:
        return MULTIPLIER_FAR

func _process(delta: float) -> void:
    if not is_retrieving:
        return
    
    current_retrieval_time += delta
    progress_bar.value = current_retrieval_time
    
    if progress_bar:
        progress_bar.value = current_retrieval_time
    
    if current_retrieval_time >= retrieval_time:
        complete_retrieval()

func complete_retrieval() -> void:
    is_retrieving = false
    
    var accuracy = calculate_accuracy()
    var information = {
        "info_id": scout_id,
        "info_type": "troop_positions",
        "data": gather_troop_positions(),
        "accuracy": accuracy,
        "source": "scout_%d" % scout_id,
        "timestamp": Time.get_unix_time_from_system(),
        "is_verified": randf() < accuracy,
        "position": deployment_position,
        "scout_level": scout_level
    }
    
    GameManager.log_event("information_retrieved", information)
    information_retrieved.emit(information)
    
    GameManager.reveal_fog_of_war(deployment_position, 8)
    
    update_sprite_based_on_status()

func gather_troop_positions() -> Dictionary:
    var troop_positions = {}
    var armies = GameManager.game_state.get("armies", [])
    
    for army in armies:
        var army_data = army.get_data() if army.has_method("get_data") else army
        if army_data.get("faction_id", 0) != faction_id:
            var uncertainty = int((1.0 - information_accuracy) * 50)
            troop_positions[str(army_data.get("army_id", 0))] = {
                "position": army_data.get("position", Vector2.ZERO),
                "unit_count": army_data.get("unit_count", 0),
                "unit_type": army_data.get("unit_type", "infantry"),
                "morale": army_data.get("morale", 100),
                "uncertainty_radius": uncertainty,
                "confidence": information_accuracy
            }
    
    return troop_positions

func calculate_accuracy() -> float:
    var base_accuracy = 0.6 + (scout_level * 0.05)
    var tactical_insight_bonus = GameManager.get_skill_effect("tactical_insight")
    var final_accuracy = min(base_accuracy + tactical_insight_bonus, 0.95)
    
    return final_accuracy

func update_sprite_based_on_status() -> void:
    if not sprite:
        return
    
    if is_deployed and not is_retrieving:
        sprite.modulate = Color.CYAN
    elif is_retrieving:
        sprite.modulate = Color.YELLOW
    else:
        sprite.modulate = Color.GREEN

func recall() -> void:
    is_active = false
    is_deployed = false
    is_retrieving = false
    visible = false
    current_retrieval_time = 0.0
    
    GameManager.log_event("scout_recall", {
        "scout_id": scout_id,
        "position": deployment_position
    })
    
    recall_complete.emit(scout_id)

func get_data() -> Dictionary:
    return {
        "scout_id": scout_id,
        "position": deployment_position,
        "is_active": is_active,
        "is_deployed": is_deployed,
        "is_retrieving": is_retrieving,
        "progress_percent": (current_retrieval_time / retrieval_time) * 100.0 if retrieval_time > 0 else 0.0,
        "accuracy": calculate_accuracy(),
        "level": scout_level
    }

func upgrade_level() -> void:
    if scout_level < 5:
        scout_level += 1
        GameManager.log_event("scout_upgrade", {
            "scout_id": scout_id,
            "new_level": scout_level
        })
