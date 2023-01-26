extends Node2D

const CELL_SIZE : int = 16 * 4

var map_size : Vector2 = Vector2(160, 200)
var max_enemy_count : int = 15
var spawn_min_distance : int = 20
var spawn_max_distance : int = 50
var rougue : RougueLikeGenerator

var slimeScene : PackedScene = preload("res://scenes/enemies/Slime.tscn")
var ghostScene : PackedScene = preload("res://scenes/enemies/Ghost.tscn")
var darkKurageScene : PackedScene = preload("res://scenes/enemies/DarkKurage.tscn")

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
	$HUD/HitPoint.text = str($Player.hit_point)
	$HUD/SkillPoint.text = str($Player.skill_point)

func _on_Player_damage_received(enemy : Node2D):
	$HUD/HitPoint.text = str($Player.hit_point)
	$FollowCamera.wiggle(enemy.attack_point * 0.6, 0.14)

func _on_Player_skill_point_changed(skill_point : int):
	$HUD/SkillPoint.text = str(skill_point)
	
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
	return (spawn_min_distance <= abs(dist.x) || spawn_min_distance <= abs(dist.y)) && abs(dist.x) <= spawn_max_distance && abs(dist.y) <= spawn_max_distance

func spawn(margin : int, enemy : Node2D):
	var poses = get_floors(margin)
	var filterd = []
	for pos in poses:
		if is_in_distance(pos):
			filterd.append(pos)
	if filterd.size() == 0:
		return
	var pos = rand_array_elem(filterd)
	enemy.position = pos * CELL_SIZE
	$Enemies.add_child(enemy)

func despawn_enemies():
	for enemy in $Enemies.get_children():
		var dist = ($Player.position - enemy.position) / CELL_SIZE 
		if abs(dist.x) > spawn_max_distance || abs(dist.y) > spawn_max_distance:
			enemy.queue_free()

func _on_SpawnTimer_timeout():
	if $Enemies.get_child_count() < max_enemy_count:
		var rand = randi() % 10
		if rand <= 6:
			var slime = slimeScene.instance()
			slime.initialize(rougue.get_bitmap(), $Player)
			spawn(3, slime)
		elif rand <= 8:
			var ghost = ghostScene.instance()
			ghost.initialize(rougue.get_bitmap(), $Player)
			spawn(2, ghost)
		else:
			var darkKurage = darkKurageScene.instance()
			darkKurage.initialize(rougue.get_bitmap(), $Player)
			spawn(3, darkKurage)
	despawn_enemies()

func _on_Button_pressed():
	$Player.attack_skill(0)

func _on_TextureButton_pressed():
	$Player.attack_normal()
