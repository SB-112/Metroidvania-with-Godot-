extends Camera2D

@onready var player: CharacterBody2D = $"../Player"

func _process(_delta: float) -> void:
	global_position.x = player.global_position.x
