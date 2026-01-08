extends CharacterBody3D

@export var speed = 10.0
@export var dash_length = 3.0
@export var bullet_scene: PackedScene
@export var hitscan_shape: BoxShape3D
@export_flags_3d_physics var hitscan_mask

@onready var attack_area_3d: Area3D = $AttackArea3D
@onready var model: Node3D = $StandardCharacter
@onready var anim_player: AnimationPlayer = $StandardCharacter/AnimationPlayer

var target_pos: Vector3
var aim_dir: Vector3

func _ready() -> void:
	anim_player.play("Idle")

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
		
	if velocity:
		anim_player.play("Sprint")
	else:
		anim_player.play("Idle")

	model.look_at(target_pos, Vector3.UP, true) # use_model_front
	attack_area_3d.look_at(target_pos)
	move_and_slide()
	
func dash():
	global_position = global_position + velocity.normalized() * dash_length
		
func shoot():
	attack_area_3d.monitoring = true
	await get_tree().create_timer(0.5).timeout
	attack_area_3d.monitoring = false
	
	# TODO: anim end -> monitoring off
	pass
	
func apply_hit(node: Node3D) -> bool:
	if node.has_method("take_hit"):
		node.take_hit()
		return true
	return false

func _on_aim_handler_aim_update(screenPos: Vector2, pos: Vector3, dir: Vector3) -> void:
	target_pos = pos
	aim_dir = dir
	
func take_hit() -> void:
	print("death")


func _on_attack_area_3d_body_entered(body: Node3D) -> void:
	apply_hit(body)
