extends Node3D

var velocity: Vector3 = Vector3.ZERO

func set_velocity(vel: Vector3):
	velocity = vel

func _process(delta):
	global_position = global_position + velocity * delta
