extends CanvasLayer
@onready var video_stream_player: VideoStreamPlayer = $Control/VideoStreamPlayer

func _ready() -> void:
	video_stream_player.play()
	await video_stream_player.finished
	SceneTransitions.change_scene("res://scenes/levels/level0.tscn")
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		video_stream_player.stop()
		SceneTransitions.change_scene("res://scenes/levels/level0.tscn")
