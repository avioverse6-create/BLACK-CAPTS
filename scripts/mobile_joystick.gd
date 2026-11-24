extends Control

const RADIUS := 66.0
const KNOB_RADIUS := 27.0
const DEADZONE := 0.12

var finger_id := -1
var axis := Vector2.ZERO
var active := false

func _ready() -> void:
    custom_minimum_size = Vector2(170, 170)
    mouse_filter = Control.MOUSE_FILTER_STOP
    queue_redraw()

func _draw() -> void:
    var center := size * 0.5
    draw_circle(center, RADIUS + 5.0, Color(0.03, 0.06, 0.09, 0.28))
    draw_circle(center, RADIUS, Color(0.10, 0.15, 0.20, 0.48))
    draw_arc(center, RADIUS, 0.0, TAU, 64, Color(0.78, 0.87, 0.96, 0.30), 2.0, true)
    var knob_center := center + axis * RADIUS
    draw_circle(knob_center, KNOB_RADIUS + 2.0, Color(0.02, 0.04, 0.07, 0.35))
    draw_circle(knob_center, KNOB_RADIUS, Color(0.72, 0.82, 0.92, 0.78))
    draw_arc(knob_center, KNOB_RADIUS, 0.0, TAU, 48, Color(0.96, 0.98, 1.0, 0.52), 1.5, true)

func _gui_input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        if event.pressed and finger_id == -1:
            finger_id = event.index
            active = true
            _update_axis(event.position)
            accept_event()
        elif not event.pressed and event.index == finger_id:
            _release_stick()
            accept_event()
    elif event is InputEventScreenDrag and event.index == finger_id:
        _update_axis(event.position)
        accept_event()
    elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        if event.pressed:
            active = true
            _update_axis(event.position)
        else:
            _release_stick()
        accept_event()
    elif event is InputEventMouseMotion and active:
        _update_axis(event.position)
        accept_event()

func _update_axis(pointer: Vector2) -> void:
    var delta := pointer - size * 0.5
    axis = delta.limit_length(RADIUS) / RADIUS
    if axis.length() < DEADZONE:
        axis = Vector2.ZERO
    _apply_actions()
    queue_redraw()

func _apply_actions() -> void:
    _set_action("ui_left", maxf(-axis.x, 0.0))
    _set_action("ui_right", maxf(axis.x, 0.0))
    _set_action("ui_up", maxf(-axis.y, 0.0))
    _set_action("ui_down", maxf(axis.y, 0.0))

func _set_action(action_name: String, strength: float) -> void:
    if strength > 0.01:
        Input.action_press(action_name, strength)
    else:
        Input.action_release(action_name)

func _release_stick() -> void:
    finger_id = -1
    active = false
    axis = Vector2.ZERO
    _apply_actions()
    queue_redraw()

func _exit_tree() -> void:
    _release_stick()
