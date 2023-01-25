extends KinematicBody2D

signal damage_received

export var WALK_SPEED : float = 500
export var GRAVITY : float = 5000
export var JUMP_VELOCITY : float = 600
export var JUMP_ACCELERATION : float = 600
export var MAX_FALL_SPEED : float = 1000
export var BURST_FALL_SPEED : float = 2000
export var BURST_SLIDE_SPEED : float = 2000

enum {LEFT, RIGHT, STOP}
var move_state_x = STOP
var is_look_right = true
var velocity = Vector2()

# var is_burst_fall = false
var is_burst_slide = STOP
var is_can_burst_slide = true

var hit_point : int = 10
var is_muteki = false;
	
func _on_BurstSlideTimer_timeout():
	is_burst_slide = STOP
	is_can_burst_slide = false
	$BurstSlideCoolTimer.start()
	
func _on_BurstSlideCoolTimer_timeout():
	is_can_burst_slide = true

func _on_Timer_timeout():
	is_muteki = false
	$Blink.stop()
	modulate.a = 1
	var overlapping_bodies = $EnemyCollisionArea.get_overlapping_bodies()
	if overlapping_bodies.size() > 0:
		if overlapping_bodies[0].is_in_group("enemies"):
			receive_damage(overlapping_bodies[0])

func receive_damage(enemy : Node2D):
	if enemy.is_in_group("enemies") && !is_muteki:
		emit_signal("damage_received", enemy)
		hit_point -= enemy.attack_point
		is_muteki = true
		$MutekiTimer.start()
		$Blink.play("Blink")
		if enemy.has_method("after_attack"):	
			enemy.after_attack()
	
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
		velocity.y = MAX_FALL_SPEED
		
	if Input.is_action_just_pressed("burst_slide") && is_burst_slide == STOP:
		if is_can_burst_slide:
			$BurstSlideTimer.start()
			if is_look_right:
				is_burst_slide = RIGHT
			else:
				is_burst_slide = LEFT
		
	$AnimatedSprite.flip_h = !is_look_right

	match move_state_x:
		LEFT:
			velocity.x = -WALK_SPEED
		RIGHT:
			velocity.x = WALK_SPEED
		STOP:
			velocity.x = 0
			
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED
		
	# if is_burst_fall:
	# 	velocity.y = BURST_FALL_SPEED 
		
	match is_burst_slide:
		LEFT:
			velocity.y = 0
			velocity.x = -BURST_SLIDE_SPEED
		RIGHT:
			velocity.y = 0
			velocity.x = BURST_SLIDE_SPEED
			
	move_and_slide(velocity, Vector2(0, -1))
	
	var is_on_floor = is_on_floor()
	
	if is_on_ceiling():
		velocity.y = 0
	if is_jump_start:
		if is_on_floor:
			velocity.y = -JUMP_VELOCITY
		else:
			if velocity.y > -JUMP_VELOCITY:
				velocity.y -= JUMP_ACCELERATION
			else:
				velocity.y = -JUMP_VELOCITY
	
	match move_state_x:
		LEFT:
			if is_on_floor:
				$AnimatedSprite.animation = "walk"
			else:
				$AnimatedSprite.animation = "fly"
		RIGHT:
			if is_on_floor:
				$AnimatedSprite.animation = "walk"
			else:
				$AnimatedSprite.animation = "fly"
		STOP:
			$AnimatedSprite.animation = "idle"
	
	# if is_burst_fall:
		# $AnimatedSprite.animation = "fall"
	if is_burst_slide != STOP:
		$AnimatedSprite.animation = "fly"
	
func _on_EnemyCollisionArea_body_entered(body : Node):
	is_burst_slide = STOP
	if body.is_in_group("enemies"):
		receive_damage(body)
