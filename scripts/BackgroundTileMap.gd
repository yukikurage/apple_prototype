extends TileMap

var map_size = Vector2(100, 200)

func generate_map():
	for y in range(0, map_size.y):
		for x in range(0, map_size.x):
			set_cell(x, y, 0, false, false, false, Vector2(x, y))

	update_bitmask_region()

func _ready():
	generate_map()
