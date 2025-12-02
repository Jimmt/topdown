class_name Enemy
extends CharacterBody3D

func _physics_process(delta: float) -> void:
	move_and_slide()

func take_hit() -> void:
	get_parent().remove_child(self)
	queue_free()
