extends CharacterBody3D

@export var speed = 60.0

func launch(dir: Vector3) -> void:
	velocity = dir.normalized() * speed
	look_at(global_position + dir * 100)

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider(0)
		if collider.has_method("take_hit"):
			collider.take_hit()
		queue_free()
