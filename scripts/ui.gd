extends Control

@onready var reticle: TextureRect = $Reticle

var aim_pos: Vector2

func _process(delta: float) -> void:
	reticle.global_position = aim_pos - reticle.size / 2
	
func _on_aim_handler_aim_update(screenPos: Vector2, pos: Vector3, dir: Vector3) -> void:
	aim_pos = screenPos
