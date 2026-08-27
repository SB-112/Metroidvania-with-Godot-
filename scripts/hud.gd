extends CanvasLayer

@onready var label: Label = $Label


func _ready() -> void:
	hide_label()

func show_label():
	label.show()

func hide_label():
	label.hide()		
