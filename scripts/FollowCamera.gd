extends Camera2D

const COEFFICIENT : int = 6

var wiggle_start = Vector2(0, 0)
var wiggle_target = Vector2(0, 0)
var wiggle_strength = 0
var followee : Node
var wiggling = false

func wiggle(strength : float, time : float):
	$WiggleTimer.wait_time = time
	$WiggleTimer.start()
	var rand_angle = rand_range(0, 2 * PI)
	wiggle_strength = strength
	wiggle_target = Vector2(cos(rand_angle), sin(rand_angle)) * wiggle_strength
	$WigglePulseTimer.start()
	wiggling = true
	
func set_followee(followee : Node):
	self.followee = followee

func _process(delta):
	var current_ratio = $WigglePulseTimer.time_left / $WigglePulseTimer.wait_time
	var wiggle_vector = current_ratio * wiggle_target + (1 - current_ratio) * wiggle_start 
	var velocity: Vector2 = followee.position - position
	position += velocity * delta * COEFFICIENT + wiggle_vector

func _on_WigglePulseTimer_timeout():
	if wiggling == true:
		if $WiggleTimer.is_stopped():
			wiggle_start = wiggle_target
			wiggle_target = Vector2(0, 0)
			wiggling = false
		else:
			wiggle_start = wiggle_target
			var rand_angle = rand_range(0, 2 * PI)
			wiggle_target = Vector2(cos(rand_angle), sin(rand_angle)) * wiggle_strength
			print(wiggle_target)
	else:
		wiggle_start = Vector2(0, 0)
		wiggle_target = Vector2(0, 0)
		$WigglePulseTimer.stop()
