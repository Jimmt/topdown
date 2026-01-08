class_name Enemy
extends CharacterBody3D

# TODO: remove
@export var player: Node3D
@export var bullet_scene: PackedScene
@export var shoot_interval_s: float = 1.5

var time_since_shoot: float = 999999.999
var mask = null

func _ready() -> void:
	var bullet = bullet_scene.instantiate() as CharacterBody3D
	mask = bullet.collision_mask

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if time_since_shoot > shoot_interval_s and has_sight_of_player():
		shoot()
	else:
		time_since_shoot += delta

# TODO: consider when player's shoulder is peeking out.		
func has_sight_of_player() -> bool:
	var space_state = get_world_3d().direct_space_state
	var from = global_position
	from.y = 1
	var to = player.global_position
	to.y = 1
	var query = PhysicsRayQueryParameters3D.create(from, to, mask)
	var result = space_state.intersect_ray(query)
	return result and result.collider == player

func shoot() -> void:
	time_since_shoot = 0
	
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position
	
	var dir = player.global_position - global_position
	dir.y = 0
	bullet.launch(dir)

func take_hit() -> void:
	get_parent().remove_child(self)
	queue_free()
