extends KinematicBody2D

var bitMap : BitMap
var player : Node2D

export var speed : float = 500.0

var attack_point = 2

func initialize(bitMap : BitMap, player : Node2D):
	self.bitMap = bitMap
	self.player = player

func _ready():
	add_to_group("enemies")

func after_attack():
	queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = (player.position - position).normalized()
	if direction.x > 0:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true
		
	move_and_slide(direction * speed, Vector2(0, -1))
