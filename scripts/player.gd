extends CharacterBody2D


enum STATES {
	FLOOR,
	JUMP,
	FALL,
	RUN,
	DOUBLE_JUMP
}

const FALL_GRAVITY := 1500.0
const FALL_VELOCITY := 1000.0
const WALK_VELOCITY := 480.0
const ACCELERATION := 2500.0
const JUMP_VELOCITY := -550.0
const JUMP_DECELERATION := 1500.0
const DOUBLE_JUMP_VELOCITY := -500

@onready var anim: AnimatedSprite2D = %AnimatedSprite2D
@onready var coyote_timer: Timer = $CoyoteTimer

var active_state := STATES.FALL
var can_double_jump := false

func _ready() -> void:
	switch_state(active_state)

func _physics_process(delta: float) -> void:
	process_state(delta)
	move_and_slide()
	
func switch_state(to_state: STATES) ->void:
	var previous_state = active_state
	active_state = to_state
	
	match active_state:
		STATES.FALL:
			if previous_state != STATES.DOUBLE_JUMP:
				anim.play("fall")
			if previous_state == STATES.FLOOR:
				coyote_timer.start()
		STATES.FLOOR:
			can_double_jump = true		
		STATES.JUMP:
			anim.play("jump");
			velocity.y = JUMP_VELOCITY
			coyote_timer.stop()	
		STATES.DOUBLE_JUMP:
			anim.play("jump")
			velocity.y = DOUBLE_JUMP_VELOCITY
			can_double_jump = false	
	
func process_state(delta: float) -> void:
	match active_state:
		STATES.FALL:
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
			if Input.get_axis("move_left", "move_right"):
				anim.play("run")
			else:
				anim.play("idle")	
			handle_movement(delta)	
			
			if not is_on_floor():
				switch_state(STATES.FALL)
			elif Input.is_action_just_pressed("jump"):
				switch_state(STATES.JUMP)		
		STATES.JUMP, STATES.DOUBLE_JUMP:
			velocity.y = move_toward(velocity.y, 0, JUMP_DECELERATION * delta)	
			handle_movement(delta)
			
			if Input.is_action_just_released("jump") or velocity.y >= 0:
				velocity.y *= 0.1
				switch_state(STATES.FALL)	
				
				
func handle_movement(delta):
	var input_direction = Input.get_axis("move_left", "move_right")
	if input_direction:
		anim.flip_h = input_direction < 0
	velocity.x = move_toward(velocity.x, input_direction * WALK_VELOCITY, ACCELERATION * delta)	
