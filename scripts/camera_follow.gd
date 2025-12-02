extends Node3D

@export var player: Node3D
@export var cursor_lock: Node3D
@export var lean_scale: float = 0.3
@export var smooth_speed: float = 3.5

var aim_dir: Vector3

func _process(delta: float) -> void:
	if !cursor_lock.is_mouse_captured():
		return
	
	var target_pos = player.global_position + aim_dir * lean_scale
	global_position = global_position.lerp(target_pos, smooth_speed * delta)

func _on_aim_handler_aim_update(screenPos: Vector2, pos: Vector3, dir: Vector3) -> void:
	aim_dir = dir
