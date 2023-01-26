extends Area2D

var attack_point = 0

var velocity = Vector2(0, 0)

func set_attack_point(attack_point):
	self.attack_point = attack_point

func set_flip(flip):
	if flip:
		scale.x = -abs(scale.x)
	else:
		scale.x = abs(scale.x)
		
func _process(delta):
	position += velocity * delta

func _on_AttackBullet_body_entered(body):
	if body.is_in_group("enemies"):
		body.damage_received(attack_point)
	queue_free()
