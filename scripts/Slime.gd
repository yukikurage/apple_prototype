extends KinematicBody2D

var GRAVITY : float = 3000
var MAX_FALL_SPEED : float = 2000
var JUMP_SPEED : float = 1300
var SPEED : float = 400

var enemy

func get_enemy() -> Enemy:
	return enemy

func _init():
	enemy = Enemy.new(1)
	
func _physics_process(delta):
	enemy.velocity.y += delta * 5000
			
	if enemy.velocity.y > MAX_FALL_SPEED:
		enemy.velocity.y = MAX_FALL_SPEED

	move_and_slide(enemy.velocity, Vector2(0, -1))
	
	if is_on_floor():
		enemy.velocity.x = 0
	

func _on_JumpTimer_timeout():
	enemy.velocity.y = -JUMP_SPEED
	var direction = (randi() % 3) - 1
	enemy.velocity.x = SPEED * direction
