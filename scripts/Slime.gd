extends KinematicBody2D

var GRAVITY : float = 3000
var MAX_FALL_SPEED : float = 2000
var JUMP_SPEED : float = 1300
var SPEED : float = 400

var bitMap : BitMap
var player : Node2D

var attack_point = 1
var velocity = Vector2(0, 0)
	
func _ready():
	add_to_group("enemies")

func initialize(bitMap : BitMap, player : Node2D):
	self.bitMap = bitMap
	self.player = player

func after_attack():
	velocity.y = -JUMP_SPEED
	var direction
	if player.position.x > position.x:
		direction = 1
	else:
		direction = -1
	velocity.x = SPEED * direction
	
func _physics_process(delta):
	velocity.y += delta * 5000
			
	if velocity.y > MAX_FALL_SPEED:
		velocity.y = MAX_FALL_SPEED

	move_and_slide(velocity, Vector2(0, -1))
	
	if is_on_floor():
		velocity.x = 0
	

func _on_JumpTimer_timeout():
	velocity.y = -JUMP_SPEED
	var direction = (randi() % 3) - 1
	velocity.x = SPEED * direction
