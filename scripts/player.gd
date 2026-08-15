extends CharacterBody2D

@onready var player: CharacterBody2D = $"."

#enums
enum STATES {
	FLOOR,
	JUMP,
	FALL,
	DOUBLE_JUMP,
	DASH
}
	
#player attributes
const FALL_GRAVITY := 1500.0
const FALL_VELOCITY := 1000.0
const WALK_VELOCITY := 330.0
const ACCELERATION := 2500.0
const JUMP_VELOCITY := -540.0
const JUMP_DECELERATION := 1300.0
const DOUBLE_JUMP_VELOCITY := -520
const WALL_SLIDE_GRAVITY := 300.0
const WALL_SLIDE_VELCITY := 500.0
const DASH_SPEED := 700.0
const DASH_DUR := 0.15
var active_dash_time := 0.0

#animatedsprite2d
@onready var anim: AnimatedSprite2D = %AnimatedSprite2D
@onready var coyote_timer: Timer = $CoyoteTimer

#particles
@onready var jump_particles: GPUParticles2D = $JumpParticles
@onready var run_particles: GPUParticles2D = $RunParticles


#sfx
@onready var player_footsteps_sfx: AudioStreamPlayer2D = $SFX/PlayerFootstepsSFX
@onready var player_jump_sfx: AudioStreamPlayer2D = $SFX/PlayerJumpSFX
@onready var player_land_sfx: AudioStreamPlayer2D = $SFX/PlayerLandSFX
@onready var player_double_jump_sfx: AudioStreamPlayer2D = $SFX/PlayerDoubleJumpSFX

#dash state
@onready var dash_timer: Timer = $DashTimer
var dash_direction := 1
var can_dash := true

#dialogue actionable
@onready var actionable_detector: Area2D = $ActionableDetector

#disable movement
var can_move:bool = true		

#state machine
var active_state := STATES.FALL
var can_double_jump := false

func _ready() -> void:
	switch_state(active_state)
	await get_tree().create_timer(1.5).timeout
	can_move = false
	anim.play("run")
	player_footsteps_sfx.play()

	var tween = create_tween()
	tween.tween_property(
		player,
		"position:x",
		player.position.x + 200,
		1.0
	)

	await tween.finished

	anim.play("idle")
	player_footsteps_sfx.stop()
	can_move = true
	
	
func _physics_process(delta: float) -> void:
	if !can_move:
		return
		
	process_state(delta)
	move_and_slide()

	
func switch_state(to_state: STATES) ->void:
	var previous_state = active_state
	active_state = to_state
	
	if previous_state == STATES.FLOOR and to_state != STATES.FLOOR:
		player_footsteps_sfx.stop()
		run_particles.emitting = false
	
	match active_state:
		STATES.FALL:
			if previous_state != STATES.DOUBLE_JUMP:
				anim.play("fall")
			if previous_state == STATES.FLOOR:
				coyote_timer.start()
				player_jump_sfx.play()
		STATES.FLOOR:
			can_double_jump = true		
			player_land_sfx.play()
			if dash_timer.is_stopped():
				can_dash = true
		STATES.JUMP:
			anim.play("jump");
			velocity.y = JUMP_VELOCITY
			coyote_timer.stop()	
			player_jump_sfx.play()
			jump_particles.restart()
		STATES.DOUBLE_JUMP:
			anim.play("jump")
			velocity.y = DOUBLE_JUMP_VELOCITY
			can_double_jump = false	
			player_double_jump_sfx.play(0.08)
			jump_particles.restart()
		STATES.DASH:
			dash_timer.start()
			active_dash_time = DASH_DUR
			player_double_jump_sfx.play()
			anim.play("dash")
			can_dash = false
			dash_direction = Input.get_axis("move_left", "move_right")
			if dash_direction == 0:
				dash_direction = -1 if anim.flip_h else 1
			velocity.x = DASH_SPEED * dash_direction
			velocity.y = 0		
	
func process_state(delta: float) -> void:
	match active_state:
		STATES.FALL:
			if try_dash():
				return
				
			velocity.y = move_toward(velocity.y, FALL_VELOCITY, FALL_GRAVITY * delta)
			handle_movement(delta)
			
			if is_on_floor():
				switch_state(STATES.FLOOR)
			elif Input.is_action_just_pressed("jump"):
				if coyote_timer.time_left > 0:
					switch_state(STATES.JUMP)	
				elif can_double_jump:
					switch_state(STATES.DOUBLE_JUMP)	
		STATES.FLOOR:
			if try_dash():
				return
				
			if Input.get_axis("move_left", "move_right"):
				anim.play("run")
				if !player_footsteps_sfx.playing:
					player_footsteps_sfx.play()
					
				# --- Add this line to turn particles on when running ---
				run_particles.emitting = true
			else:
				anim.play("idle")
				player_footsteps_sfx.stop()
				
				# --- Add this line to turn particles off when standing still ---
				run_particles.emitting = false
				
			handle_movement(delta)	
			
			if not is_on_floor():
				switch_state(STATES.FALL)
			elif Input.is_action_just_pressed("jump"):
				switch_state(STATES.JUMP)
		STATES.JUMP, STATES.DOUBLE_JUMP:
			if try_dash():
				return
				
			velocity.y = move_toward(velocity.y, 0, JUMP_DECELERATION * delta)	
			handle_movement(delta)
			
			if Input.is_action_just_released("jump") or velocity.y >= 0:
				velocity.y *= 0.1
				switch_state(STATES.FALL)	
		STATES.DASH:
			velocity.x =DASH_SPEED * dash_direction
			velocity.y = 0		
			
			active_dash_time -= delta
			if active_dash_time <= 0.0:
				if is_on_floor():
					switch_state(STATES.FLOOR)
				else:
					switch_state(STATES.FALL)	
				
				
func handle_movement(delta):
	var input_direction = Input.get_axis("move_left", "move_right")
	if input_direction:
		anim.flip_h = input_direction < 0
	velocity.x = move_toward(velocity.x, input_direction * WALK_VELOCITY, ACCELERATION * delta)	

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		var actionables = actionable_detector.get_overlapping_areas()
		if actionables.size() > 0:
			can_move = false
			LetterBoxEffect.show_bars()
			actionables[0].action()
			DialogueManager.dialogue_ended.connect(_on_dialogue_finished, CONNECT_ONE_SHOT)
			return
			
func _on_dialogue_finished(_resource) -> void:
	LetterBoxEffect.hide_bars()
	can_move = true


func _on_dash_timer_timeout() -> void:
	can_dash = true
	if is_on_floor():
		switch_state(STATES.FLOOR)
	else:
		switch_state(STATES.FALL)	

func try_dash() -> bool:
	if Input.is_action_just_pressed("dash") and can_dash:
		switch_state(STATES.DASH)
		return true
	return false	
	
