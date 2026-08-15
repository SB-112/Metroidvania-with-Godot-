extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var buttons: VBoxContainer = $Buttons
@onready var options_menu: ColorRect = $OptionsMenu
@onready var background_music: AudioStreamPlayer2D = $BackgroundMusic

func _ready() -> void:
	animation_player.play("FadeIn")
	buttons.visible = true
	options_menu.visible = false
	background_music.play()

func _on_start_pressed() -> void:
	SceneTransitions.change_scene("res://scenes/intro_cutscene.tscn")

func _on_options_pressed() -> void:
	buttons.visible = false
	options_menu.visible = true

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_back_button_pressed() -> void:
	buttons.visible = true
	options_menu.visible = false
