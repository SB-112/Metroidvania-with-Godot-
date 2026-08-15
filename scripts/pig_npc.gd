extends Node2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	if States.bell_rang:
		leave()

func leave():
	anim.play("run")

	var tween = create_tween()
	tween.tween_property(self, "position:x", position.x + 300, 1.5)
	await tween.finished

	queue_free()

	
