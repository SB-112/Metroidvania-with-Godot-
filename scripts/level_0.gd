extends Node2D

@onready var ambience_music: AudioStreamPlayer2D = $AmbienceMusic

func _ready() -> void:
	ambience_music.play()
