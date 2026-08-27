extends Node

var has_met_Hiro = false
var bell_rang = false
var gate_openable = false
var last_checkpoint_position: Vector2 = Vector2.ZERO
var has_checkpoint: bool = false
var has_talked_to_guard: bool = false

func _ready() -> void:
	has_met_Hiro = false
