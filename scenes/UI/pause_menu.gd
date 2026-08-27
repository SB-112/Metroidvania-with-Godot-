extends CanvasLayer

@onready var panel: ColorRect = $ColorRect

func _ready() -> void:
	panel.hide()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		panel.show()
		get_tree().paused = true
		


func _on_continue_pressed() -> void:
	panel.hide()
	get_tree().paused = false


func _on_exit_pressed() -> void:
	SceneTransitions.change_scene("res://scenes/UI/main_menu.tscn")
	get_tree().paused = false
