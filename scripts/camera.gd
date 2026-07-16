extends Camera2D

var lookahead_distance = 100.0
var lookahead_speed = 2.0

@onready var player = get_parent()

func _process(delta: float) -> void:
	var target_offset = 0.0
	if player.velocity.x > 10:
		target_offset = lookahead_distance
	elif player.velocity.x < -10:
		target_offset = -lookahead_distance
	
	offset.x = lerp(offset.x, target_offset, lookahead_speed * delta)		
