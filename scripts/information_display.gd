extends Panel

class_name InformationDisplay

var information_items: Array = []
var max_info_age: float = 300.0

@onready var info_list = $VBoxContainer/InfoList
@onready var header_label = $Header/InfoCount
@onready var accuracy_label = $Header/Accuracy

func _ready() -> void:
    setup_ui()
    update_display()

func setup_ui() -> void:
    pass

func _process(_delta: float) -> void:
    cleanup_old_information()
    update_display()

func add_information(info: Dictionary) -> void:
    info["timestamp"] = Time.get_unix_time_from_system()
    info["display_id"] = information_items.size()
    information_items.append(info)
    
    GameManager.log_event("information_received", {
        "type": info.get("info_type", "unknown"),
        "accuracy": info.get("accuracy", 0.0),
        "source": info.get("source", "unknown")
    })
    
    update_display()

func cleanup_old_information() -> void:
    var current_time = Time.get_unix_time_from_system()
    var to_remove = []
    
    for i in range(information_items.size()):
        var age = current_time - information_items[i].get("timestamp", 0.0)
        if age > max_info_age:
            to_remove.append(i)
    
    for index in to_remove:
        information_items.remove_at(index)
    
    if to_remove.size() > 0:
        update_display()

func update_display() -> void:
    if not info_list:
        return
    
    for child in info_list.get_children():
        child.queue_free()
    
    if information_items.is_empty():
        var empty_label = Label.new()
        empty_label.text = "No information available"
        empty_label.modulate = Color.GRAY
        info_list.add_child(empty_label)
        
        if header_label:
            header_label.text = "Information: 0"
        if accuracy_label:
            accuracy_label.text = "Avg Accuracy: N/A"
        return
    
    var total_accuracy = 0.0
    for info in information_items:
        total_accuracy += info.get("accuracy", 0.0)
    
    var avg_accuracy = total_accuracy / information_items.size()
    
    if header_label:
        header_label.text = "Information: %d" % information_items.size()
    if accuracy_label:
        accuracy_label.text = "Avg Accuracy: %.0f%%" % (avg_accuracy * 100)
    
    for info in information_items:
        var info_item = create_info_item(info)
        info_list.add_child(info_item)

func create_info_item(info: Dictionary) -> Panel:
    var panel = Panel.new()
    panel.custom_minimum_size = Vector2(380, 120)
    
    var vbox = VBoxContainer.new()
    panel.add_child(vbox)
    
    var header_hbox = HBoxContainer.new()
    vbox.add_child(header_hbox)
    
    var type_label = Label.new()
    type_label.text = get_info_type_label(info.get("info_type", "unknown"))
    type_label.add_theme_font_size_override("font_size", 16)
    type_label.add_theme_color_override("font_color", get_info_type_color(info.get("info_type", "unknown")))
    header_hbox.add_child(type_label)
    
    var spacer = Control.new()
    spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    header_hbox.add_child(spacer)
    
    var accuracy_badge = create_accuracy_badge(info.get("accuracy", 0.0))
    header_hbox.add_child(accuracy_badge)
    
    var source_label = Label.new()
    source_label.text = "Source: %s" % info.get("source", "unknown")
    source_label.modulate = Color.GRAY
    source_label.add_theme_font_size_override("font_size", 12)
    vbox.add_child(source_label)
    
    var age_label = Label.new()
    var age = Time.get_unix_time_from_system() - info.get("timestamp", 0.0)
    age_label.text = "Age: %ds ago" % int(age)
    age_label.modulate = Color.GRAY
    age_label.add_theme_font_size_override("font_size", 10)
    vbox.add_child(age_label)
    
    var data_text = Label.new()
    var data_content = format_info_data(info.get("data", {}))
    data_text.text = data_content
    data_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    data_text.custom_minimum_size = Vector2(360, 0)
    vbox.add_child(data_text)
    
    return panel

func create_accuracy_badge(accuracy: float) -> Label:
    var badge = Label.new()
    badge.text = "%.0f%%" % (accuracy * 100)
    badge.add_theme_font_size_override("font_size", 12)
    
    if accuracy >= 0.9:
        badge.modulate = Color.GREEN
    elif accuracy >= 0.6:
        badge.modulate = Color.YELLOW
    else:
        badge.modulate = Color.RED
    
    return badge

func get_info_type_label(info_type: String) -> String:
    match info_type:
        "troop_positions":
            return "Troop Positions"
        "enemy_strength":
            return "Enemy Strength"
        "scout_report":
            return "Scout Report"
        _:
            return info_type.capitalize()

func get_info_type_color(info_type: String) -> Color:
    match info_type:
        "troop_positions":
            return Color.CYAN
        "enemy_strength":
            return Color.ORANGE
        "scout_report":
            return Color.LIME_GREEN
        _:
            return Color.WHITE

func format_info_data(data: Dictionary) -> String:
    if data.is_empty():
        return "No details available"
    
    var formatted = ""
    var keys = data.keys()
    
    for i in range(min(keys.size(), 3)):
        var key = keys[i]
        var value = data[key]
        var value_str = str(value)
        
        if value_str.length() > 30:
            value_str = value_str.substr(0, 27) + "..."
        
        formatted += "%s: %s" % [key.capitalize(), value_str]
        if i < min(keys.size(), 3) - 1:
            formatted += "\n"
    
    if keys.size() > 3:
        formatted += "\n(+%d more items)" % (keys.size() - 3)
    
    return formatted

func get_average_accuracy() -> float:
    if information_items.is_empty():
        return 0.0
    
    var total = 0.0
    for info in information_items:
        total += info.get("accuracy", 0.0)
    
    return total / information_items.size()

func clear_all_information() -> void:
    information_items.clear()
    update_display()
    
    GameManager.log_event("information_cleared", {
        "count": information_items.size()
    })

func get_information_count() -> int:
    return information_items.size()

func get_information_by_type(info_type: String) -> Array:
    var filtered = []
    for info in information_items:
        if info.get("info_type", "") == info_type:
            filtered.append(info)
    return filtered
