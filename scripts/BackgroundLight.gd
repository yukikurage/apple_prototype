extends Light2D

func randomize_animation_offset():
	$AnimationPlayer.set_speed_scale(rand_range(0.1, 0.3))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
