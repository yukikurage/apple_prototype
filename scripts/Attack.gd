extends Area2D

var attack_point = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("attack")

func set_attack_point(attack_point):
	self.attack_point = attack_point

func _on_AnimatedSprite_animation_finished():
	queue_free()

func _on_Timer_timeout():
	for body in get_overlapping_bodies():
		if body.is_in_group("enemies"):
			body.damage_received(attack_point)

func set_flip(flip):
	if flip:
		scale.x = -abs(scale.x)
	else:
		scale.x = abs(scale.x)
