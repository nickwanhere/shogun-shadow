extends Node2D

class_name DamageIndicator

var text_value
var indicator_position: Vector2
var lifetime: float = 1.0
var color: Color = Color.WHITE
var label: Label

func _ready() -> void:
    setup_label()

func setup_label() -> void:
    label = Label.new()
    label.add_theme_font_size_override("font_size", 24)
    label.add_theme_color_override("font_color", color)
    label.z_index = 100
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    add_child(label)

func initialize(damage_amount, start_position: Vector2, indicator_color: Color = Color.RED) -> void:
    text_value = damage_amount
    global_position = start_position
    color = indicator_color
    
    if label:
        if typeof(damage_amount) == TYPE_INT:
            label.text = str(damage_amount)
        else:
            label.text = str(damage_amount)
        label.modulate = color

func _process(delta: float) -> void:
    global_position.y -= 50.0 * delta
    lifetime -= delta
    
    if label:
        label.modulate.a = lifetime
    
    if lifetime <= 0:
        queue_free()
