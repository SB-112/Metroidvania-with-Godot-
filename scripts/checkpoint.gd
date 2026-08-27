extends Area2D

@export var is_one_shot: bool = true
var is_active: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		States.last_checkpoint_position = global_position
		States.has_checkpoint = true
		
		$AudioStreamPlayer2D.play()
		
		is_active = true
		
		if is_one_shot:
			set_deferred("monitoring", false)
