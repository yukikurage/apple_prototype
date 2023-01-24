extends TileMap

func set_cells(map: BitMap):
	for x in range(0, map.get_size().x):
		for y in range(0, map.get_size().y):
			if !map.get_bit(Vector2(x, y)):
				set_cell(x, y, 0)
	
func make_wall(map: BitMap):
	for x in range(-20, map.get_size().x + 20):
		for y in range(-20, map.get_size().y + 20):
			if x < 0 || x >= map.get_size().x || y < 0 || y >= map.get_size().y:
				set_cell(x, y, 0)

func _ready():
	pass
