extends KinematicBody2D

export var WALK_SPEED : float = 800
export var GRAVITY : float = 2500
export var JUMP_VELOCITY : float = 600
export var JUMP_ACCELERATION : float = 300
export var MAX_FALL_SPEED : float = 1000
export var BURST_FALL_SPEED : float = 3000
export var BURST_SLIDE_SPEED : float = 2500

enum {LEFT, RIGHT, STOP}
var move_state_x = STOP
var is_look_right = true
var velocity = Vector2()

var is_burst_fall = false
var is_burst_slide = STOP

func _ready():
	pass
	
func _physics_process(delta):
	velocity.y += delta * GRAVITY
	move_state_x = STOP
	var is_jump_start = false
	
	if Input.is_action_pressed("ui_right"):
		move_state_x = RIGHT
		is_look_right = true

	if Input.is_action_pressed("ui_left"):
		move_state_x = LEFT
		is_look_right = false

	if Input.is_action_pressed("ui_up"):
		is_jump_start = true
	
	if Input.is_action_pressed("ui_down"):
		is_burst_fall = true
		
	if Input.is_action_pressed("burst_slide") && is_burst_slide == STOP:
		$BurstSlideTimer.start()
		if is_look_right:
			is_burst_slide = RIGHT
		else:
			is_burst_slide = LEFT
		
	$AnimatedSprite.flip_h = !is_look_right

	match move_state_x:
		LEFT:
			$AnimatedSprite.animation = "walk"
			velocity.x = -WALK_SPEED
		RIGHT:
			$AnimatedSprite.animation = "walk"
			velocity.x = WALK_SPEED
		STOP:
			$AnimatedSprite.animation = "idle"
			velocity.x = 0
			
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED
		
	if is_burst_fall:
		velocity.y = BURST_FALL_SPEED 
		
	match is_burst_slide:
		LEFT:
			velocity.y = 0
			velocity.x = -BURST_SLIDE_SPEED
		RIGHT:
			velocity.y = 0
			velocity.x = BURST_SLIDE_SPEED
			
	move_and_slide(velocity, Vector2(0, -1))
	
	if is_on_floor():
		is_burst_fall = false
	if is_jump_start:
		if is_on_floor():
			velocity.y = -JUMP_VELOCITY
		else:
			if velocity.y > -JUMP_VELOCITY:
				velocity.y -= JUMP_ACCELERATION
			else:
				velocity.y = -JUMP_VELOCITY

func _on_BurstSlideTimer_timeout():
	is_burst_slide = STOP
