extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"
@export var interaction_sound: AudioStream

@onready var e_prompt: TextureRect = $TextureRect
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer

func _ready() -> void:
	e_prompt.hide()

func _on_body_entered(body):
	if body.is_in_group("player"):
		e_prompt.show()

func _on_body_exited(body):
	if body.is_in_group("player"):
		e_prompt.hide()

func action():
	e_prompt.hide()

	if interaction_sound:
		audio_stream_player.stream = interaction_sound
		audio_stream_player.play()

	DialogueManager.show_dialogue_balloon(dialogue_resource, dialogue_start)

func _on_dialogue_finished(_resource) -> void:
	get_tree().paused = false
