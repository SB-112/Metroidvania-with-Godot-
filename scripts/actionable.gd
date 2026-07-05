extends Area2D

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

@onready var e_prompt: Label = $Label
	
func _ready() -> void:
	e_prompt.hide()
	
func _on_body_entered(body):
	if body.is_in_group("player"):
		e_prompt.show()
		print("hello world")

func _on_body_exited(body):
	if body.is_in_group("player"):
		e_prompt.hide()		
func action():
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_start)
