extends Node

signal move_player(direction: String)
signal attack()
signal block(should_block: bool)
signal call_meeting()
signal select_army(army_id: int)
signal move_army(destination: Vector2)
signal deploy_scout(position: Vector2)
signal toggle_scout_ui()
signal toggle_info_ui()

func _input(event: InputEvent) -> void:
    if event is InputEventKey:
        _handle_key_input(event)
    elif event is InputEventMouseButton:
        _handle_mouse_input(event)

func _handle_key_input(event: InputEventKey) -> void:
    if not event.pressed:
        return
    
    match event.keycode:
        KEY_W, KEY_UP:
            move_player.emit("north")
        KEY_S, KEY_DOWN:
            move_player.emit("south")
        KEY_A, KEY_LEFT:
            move_player.emit("west")
        KEY_D, KEY_RIGHT:
            move_player.emit("east")
        KEY_SPACE:
            attack.emit()
        KEY_SHIFT:
            block.emit(true)
        KEY_M:
            call_meeting.emit()
        KEY_S:
            toggle_scout_ui.emit()
        KEY_I:
            toggle_info_ui.emit()

func _handle_mouse_input(event: InputEventMouseButton) -> void:
    if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
        attack.emit()
    elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
        var mouse_pos = get_viewport().get_mouse_position()
        if Input.is_key_pressed(KEY_CONTROL):
            deploy_scout.emit(mouse_pos)
        else:
            block.emit(true)

func _unhandled_key_input(event: InputEvent) -> void:
    if event is InputEventKey and event.keycode == KEY_SHIFT and not event.pressed:
        block.emit(false)
