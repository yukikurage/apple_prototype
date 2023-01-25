class_name RougueLikeGenerator

var room_size_range : Rect2 = Rect2(Vector2(12, 12), Vector2(16, 16))
var path_width : int = 2
var min_vertical_length : int = 15
var max_vertical_length : int = 20
var min_horizonal_length : int = 90
var max_horizonal_length : int = 140
var room_gen_num : int = 4
var path_gen_num : int = 6
var noise_gen_num : int = 3

var map_cells : BitMap
var noise : OpenSimplexNoise

func get_bitmap() -> BitMap:
	return map_cells

func _init(map_size: Vector2):
	map_cells = BitMap.new()
	map_cells.create(map_size)
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.period = 10.0
	
func get_true_bit_by_order(order : int) -> Vector2:
	var count = 0
	for x in range(0, map_cells.get_size().x):
		for y in range(0, map_cells.get_size().y):
			if map_cells.get_bit(Vector2(x, y)):
				if count == order:
					return Vector2(x, y)
				count += 1
	return Vector2(-1, -1)
	
func get_random_true_bit() -> Vector2:
	var order = randi() % map_cells.get_true_bit_count()
	return get_true_bit_by_order(order)
	
func randi_v(vect : Vector2):
	var x
	if vect.x == 0:
		x = 0
	else:
		x = randi() % int(vect.x)
	
	var y
	if vect.y == 0:
		y = 0
	else:
		y = randi() % int(vect.y)
		
	return Vector2(x, y)

func rand_range_rect(rect: Rect2):
	return rect.position + randi_v(rect.size)
		
func get_map_rect() -> Rect2:
	var size = map_cells.get_size()
	return Rect2(Vector2(0, 0), size)

func generate_room():
	var base_pos = get_random_true_bit()
	var size = rand_range_rect(room_size_range)
	var pos = rand_range_rect(Rect2(base_pos - size, size))
	var room = Rect2(pos, size).clip(get_map_rect())
	map_cells.set_bit_rect(room, true)
			
func rand_range_i(left : int, right : int):
	if left == right:
		return left
	return left + randi() % (right - left)

func generate_noise():
	var map_cells_copy = BitMap.new()
	map_cells_copy.create(map_cells.get_size())
	for x in range(0, map_cells.get_size().x):
		for y in range(0, map_cells.get_size().y):
			if map_cells.get_bit(Vector2(x, y)):
				map_cells_copy.set_bit(Vector2(x, y), true)
			else:
				if (map_cells.get_bit(Vector2(x - 1, y)) 
					|| map_cells.get_bit(Vector2(x, y - 1)) 
					|| map_cells.get_bit(Vector2(x + 1, y)) 
					|| map_cells.get_bit(Vector2(x, y + 1))) && noise.get_noise_2d(x, y) >= 0:
					map_cells_copy.set_bit(Vector2(x, y), true)
	map_cells = map_cells_copy

func generate_paths():
	var verticals = [Vector2(map_cells.get_size().x / 2, 0)]
	var horizonals = []
	while(verticals[verticals.size() - 1].y < map_cells.get_size().y):
		var vertical : Vector2 = verticals[verticals.size() - 1]
		var horizonal_length : int = int(rand_range(min_horizonal_length, max_horizonal_length))
		var horizonal_position : int = int(rand_range(vertical.x - horizonal_length + path_width, vertical.x))
		var horizonal : Rect2 = Rect2(Vector2(horizonal_position, vertical.y), Vector2(horizonal_length, path_width)).clip(get_map_rect())
		map_cells.set_bit_rect(horizonal, true)
		horizonals.append(horizonal)

		var vertical_position : int = int(rand_range(horizonal.position.x, horizonal.end.x - path_width))
		var vertical_length : int = int(rand_range(min_vertical_length, max_vertical_length))
		var next_vertical : Rect2 = Rect2(Vector2(vertical_position, horizonal.end.y), Vector2(path_width, vertical_length)).clip(get_map_rect())
		map_cells.set_bit_rect(next_vertical, true)
		verticals.append(next_vertical.end)
	for i in range(0, path_gen_num):
		var horizonal = horizonals[randi() % horizonals.size()]
		var vertical_position : int = int(rand_range(horizonal.position.x, horizonal.end.x))
		var vertical_length : int = int(rand_range(min_vertical_length, max_vertical_length))
		var next_vertical : Rect2 = Rect2(Vector2(vertical_position, horizonal.end.y), Vector2(path_width, vertical_length)).clip(get_map_rect())
		map_cells.set_bit_rect(next_vertical, true)
		verticals.append(next_vertical)
		
func grow():
	var map_cells_copy = BitMap.new()
	map_cells_copy.create(map_cells.get_size())
	for x in range(0, map_cells.get_size().x):
		for y in range(0, map_cells.get_size().y):
			if map_cells.get_bit(Vector2(x, y)):
				map_cells_copy.set_bit(Vector2(x, y), true)
			else:
				if (map_cells.get_bit(Vector2(x - 1, y)) 
					|| map_cells.get_bit(Vector2(x, y - 1)) 
					|| map_cells.get_bit(Vector2(x + 1, y)) 
					|| map_cells.get_bit(Vector2(x, y + 1))
				   ):
					map_cells_copy.set_bit(Vector2(x, y), true)
	map_cells = map_cells_copy
	

func generaete():
	generate_paths()
	for i in room_gen_num:
		generate_room()
	for i in noise_gen_num:
		generate_noise()
	grow()
	
