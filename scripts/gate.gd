extends Node2D

@onready var collision = $StaticBody2D/CollisionShape2D

func open():
	collision.set_deferred("disabled", true)

	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y + 160, 1.0)

func _input(_event: InputEvent) -> void:
	if States.gate_openable:
		if Input.is_action_just_pressed("interact"):
			open()
