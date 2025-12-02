extends Node3D

var captured_mode = Input.MOUSE_MODE_CAPTURED

func is_mouse_captured():
	return Input.mouse_mode == captured_mode

func _ready() -> void:
	Input.set_mouse_mode(captured_mode)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if is_mouse_captured():
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(captured_mode)
