extends Node2D

@onready var ambience_music: AudioStreamPlayer2D = $AmbienceMusic
@onready var ambience_music_2: AudioStreamPlayer2D = $AmbienceMusic2

func _ready() -> void:
	ambience_music.play()
	ambience_music_2.play()
