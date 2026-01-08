extends CharacterBody3D

@export var speed = 10.0
@export var dash_length = 3.0
@export var bullet_scene: 	PackedScene
@export var hitscan_shape: BoxShape3D
@export_flags_3d_physics var hitscan_mask

var target_pos: Vector3
var aim_dir: Vector3

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	if Input.is_action_just_pressed("dash"):
		dash()

	move_and_slide()
	
func dash():
	global_position = global_position + velocity.normalized() * dash_length
		
func shoot():
	var bullet: Node3D = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = global_position + aim_dir.normalized()
	bullet.global_position.y = 1
	bullet.look_at(target_pos, Vector3.UP, true)
	bullet.set_velocity(aim_dir.normalized() * 250)
	
	var cross = aim_dir.cross(Vector3.UP).normalized()
	var half_width = 0.5
		
	var center_hit = fire_raycast(Vector3.ZERO)
	var left_hit = fire_raycast(cross * -half_width)
	var right_hit = fire_raycast(cross * half_width)
	
	# TODO: use the hit position to make the bullet effect end there.
	if not apply_hit(center_hit):
		if not apply_hit(left_hit):
			if not apply_hit(right_hit):
				pass
	
func apply_hit(node: Node3D) -> bool:
	if node.has_method("take_hit"):
		node.take_hit()
		return true
	return false
	
func fire_raycast(offset: Vector3) -> Node3D:
	var space = get_world_3d().direct_space_state
	
	var query = PhysicsRayQueryParameters3D.new()
	# Prevent raycast from being at y=0.
	query.from = global_position + offset + Vector3.UP * 1
	query.to = query.from + aim_dir.normalized() * 100
	query.collision_mask = hitscan_mask
	query.exclude = [self]
	
	var result = space.intersect_ray(query)

	#DebugDraw3D.draw_arrow_ray(query.from, (query.to - query.from), (query.to - query.from).length())
	if result:
		var collider = result.collider
		return collider
	return result

func _on_aim_handler_aim_update(screenPos: Vector2, pos: Vector3, dir: Vector3) -> void:
	target_pos = pos
	aim_dir = dir
	
func take_hit() -> void:
	print("death")
