extends GPUParticles2D

@export var camera_2d: Camera2D 

func _process(delta: float) -> void:
	global_position = camera_2d.global_position + Vector2(0, -324)
