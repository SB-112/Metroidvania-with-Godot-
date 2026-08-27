extends Area2D

# Set this to Hiro's starting position in the level as a fallback
@export var level_start_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		respawn_player(body)

func respawn_player(player: CharacterBody2D) -> void:
	player.can_move = false
	player.velocity = Vector2.ZERO
	
	if LetterBoxEffect:
		LetterBoxEffect.show_bars()
	
	await get_tree().create_timer(0.3).timeout
	
	if States.has_checkpoint:
		player.global_position = States.last_checkpoint_position
	else:
		player.global_position = level_start_position
	
	await get_tree().create_timer(0.2).timeout
	
	if LetterBoxEffect:
		LetterBoxEffect.hide_bars()
		
	player.can_move = true
