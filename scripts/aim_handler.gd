extends Node3D

@export var sensitivity: float = 0.4
@onready var player: Node3D = get_parent().get_node("Player")
var aim_target_offset: Vector2 = Vector2.ZERO

signal aim_update(screenPos: Vector2, pos: Vector3, dir: Vector3)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var delta_movement = event.relative
		var scaled_delta = delta_movement * sensitivity
		aim_target_offset += scaled_delta
		
		var viewport_size = get_viewport().get_visible_rect().size
		aim_target_offset.x = clampf(aim_target_offset.x, -viewport_size.x / 2.0, viewport_size.x / 2.0)
		aim_target_offset.y = clampf(aim_target_offset.y, -viewport_size.y / 2.0, viewport_size.y / 2.0)
		
func target_pos(screen_pos) -> Vector3:
	var camera: Camera3D = get_viewport().get_camera_3d()
	
	# Cast a ray from the camera through the mouse position
	var ray_start: Vector3 = camera.project_ray_origin(screen_pos)
	var ray_end: Vector3 = camera.project_ray_normal(screen_pos) * 1000.0 + ray_start
	var ground_plane = Plane(Vector3.UP, 0.0)

	# Get the point where the ray intersects the ground plane
	return ground_plane.intersects_ray(ray_start, ray_end - ray_start)
		
func aim_dir(screen_pos) -> Vector3:
	var target_point = target_pos(screen_pos)
	var start_position: Vector3 = player.global_position
	return target_point - start_position
		
func _process(delta: float) -> void:
	var aim_pos = get_viewport().get_visible_rect().size / 2 + aim_target_offset
	var aim_dir = aim_dir(aim_pos)
	emit_signal("aim_update", aim_pos, target_pos(aim_pos), aim_dir)
