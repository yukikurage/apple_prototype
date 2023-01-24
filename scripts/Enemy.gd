class_name Enemy

var attack_point
var velocity = Vector2(0, 0)

func _init(attack_point : int):
	self.attack_point= attack_point
