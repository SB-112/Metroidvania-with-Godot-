# letterbox.gd
extends CanvasLayer

@onready var top_bar: ColorRect = $TopBar
@onready var bottom_bar: ColorRect = $BottomBar

const BAR_HEIGHT := 80.0
const SLIDE_DURATION := 0.3

func _ready() -> void:
	top_bar.position.y = 0
	bottom_bar.position.y = get_viewport().size.y
	top_bar.size.y = 0
	bottom_bar.size.y = 0
	
func show_bars() -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(top_bar, "size:y", BAR_HEIGHT, SLIDE_DURATION)
	tween.tween_property(bottom_bar, "size:y", BAR_HEIGHT, SLIDE_DURATION)
	tween.tween_property(bottom_bar, "position:y", get_viewport().size.y - BAR_HEIGHT, SLIDE_DURATION)

func hide_bars() -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property(top_bar, "size:y", 0.0, SLIDE_DURATION)
	tween.tween_property(bottom_bar, "size:y", 0.0, SLIDE_DURATION)
	tween.tween_property(bottom_bar, "position:y", get_viewport().size.y, SLIDE_DURATION)
