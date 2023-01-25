extends KinematicBody2D

var velocity

var attack_point = 1

func initialize(velocity: Vector2):
	self.velocity = velocity

func _ready():
	add_to_group("enemies")

func after_attack():
	queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide(velocity, Vector2(0, -1))
	if get_slide_count() > 0:
		queue_free()
