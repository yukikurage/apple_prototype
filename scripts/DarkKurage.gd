extends KinematicBody2D

const CELL_SIZE : int = 16 * 4

var bitMap : BitMap
var player : Node2D

export var speed : float = 300.0
var warp_dist : float = 300.0

var attack_point = 3
var is_warning = false
var warning_range = 14
var empty_test_range = 2

var bullet_scene = preload("res://scenes/enemies/DarkKurageBullet.tscn")
var bullet_range = 8
var stop_range = 2
var bullet_speed = 1000.0

func initialize(bitMap : BitMap, player : Node2D):
	self.bitMap = bitMap
	self.player = player

func _ready():
	add_to_group("enemies")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (player.position - position).length() > stop_range * CELL_SIZE:
		var direction = (player.position - position).normalized() 
		if direction.x > 0:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
		
		move_and_slide(direction * speed, Vector2(0, -1))

	if (player.position - position).length() < warning_range * CELL_SIZE:
		is_warning = true
	else:
		is_warning = false

func _on_BulletTimer_timeout():
	if is_warning && (player.position - position).length() < bullet_range * CELL_SIZE:
		var bullet : Node2D = bullet_scene.instance()
		bullet.initialize((player.position - position).normalized() * bullet_speed)
		bullet.position = position
		get_parent().add_child(bullet)

func is_empty(pos : Vector2) -> bool:
	var tile_pos = pos / CELL_SIZE
	for i in range(int(tile_pos.x - empty_test_range), int(tile_pos.x + empty_test_range + 1)):
		for j in range(int(tile_pos.y - empty_test_range), int(tile_pos.y + empty_test_range + 1)):
			print(i, j)
			if 0 <= i && i < bitMap.get_size().x && 0 <= j && j < bitMap.get_size().y && !bitMap.get_bit(Vector2(i, j)):
				print("not empty")
				return false
	return true

func _on_WarpTimer_timeout():
	if is_warning:
		var target_pos = (player.position - position).normalized() * warp_dist + position
		print(position)
		print(target_pos)
		if is_empty(target_pos):
			position = target_pos
