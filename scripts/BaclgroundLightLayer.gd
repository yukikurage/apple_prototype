extends ParallaxLayer

var map_size = Vector2(100, 200)

var backgroundLight = preload("res://scenes/BackgroundLight.tscn")

func generate_map():
	for y in range(0, map_size.y):
		for x in range(0, map_size.x):
			if rand_range(0, 1000) >= 999:
				var bgLight = backgroundLight.instance()
				bgLight.randomize_animation_offset()
				bgLight.position = Vector2(x * 16 * 4, y * 16 * 4)
				add_child(bgLight)

func _ready():
	generate_map()
