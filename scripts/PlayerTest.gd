extends Node2D

const CELL_SIZE : int = 16 * 4

var map_size : Vector2 = Vector2(160, 200)
var max_enemy_count : int = 100
var spawn_min_distance : int = 20
var rougue : RougueLikeGenerator

var slimeScene = preload("res://scenes/enemies/Slime.tscn")

func _init():
	randomize()
	
func _ready():
	$Player.position = Vector2(CELL_SIZE * int(map_size.x / 2) , CELL_SIZE * 2)
	rougue = RougueLikeGenerator.new(map_size)
	rougue.generaete()
	$TileMap.set_cells(rougue.get_bitmap())
	$TileMap.make_wall(rougue.get_bitmap())
	$TileMap.update_bitmask_region()
	$FollowCamera.set_followee($Player)

func _on_Player_damage_received():
	$HUD/HitPoint.text = str($Player.hit_point)
	$FollowCamera.wiggle(0.6, 0.15)
	
func rand_array_elem(array : Array):
	return array[randi() % array.size()]
	
func get_floors(margin : int) -> Array:
	var floors : Array = []
	for x in range(0, map_size.x):
		for y in range(margin - 1, map_size.y - 1):
			if rougue.get_bitmap().get_bit(Vector2(x, y)) && !rougue.get_bitmap().get_bit(Vector2(x, y + 1)):
				var check_magin = true
				for i in range(0, margin):
					if !rougue.get_bitmap().get_bit(Vector2(x, y - i)):
						check_magin = false
				floors.append(Vector2(x, y))
	return floors
	
func is_in_distance(pos : Vector2) -> bool:
	var dist = $Player.position / CELL_SIZE - pos
	return (spawn_min_distance <= abs(dist.x) || spawn_min_distance <= abs(dist.y))

func spawn(margin : int, enemyScene : PackedScene):
	var poses = get_floors(margin)
	var filterd = []
	for pos in poses:
		if is_in_distance(pos):
			filterd.append(pos)
	if filterd.size() == 0:
		return
	var pos = rand_array_elem(filterd)
	var enemy = enemyScene.instance()
	enemy.position = pos * CELL_SIZE
	$Enemies.add_child(enemy)

func _on_SpawnTimer_timeout():
	if $Enemies.get_child_count() < max_enemy_count:
		spawn(3, slimeScene)
