extends Camera2D

# Camera of the game. It's limits are set by two position2Ds and
# screen shake is performed by changing the offset.

onready var shake_timer = $ShakeTimer
onready var topLeft = $Limits/TopLeft
onready var bottomRight = $Limits/BottomRight
export var amplitude: float = 6.0
export var duration: float = 0.8 setget _set_duration 
export (float, EASE) var DAMP_EASING = 1.0 
export var shake = false setget _set_shake

func _ready():
	randomize()
	shake_timer.connect("timeout", self, "_on_ShakeTimer_timeout")
	self.duration = duration

	limit_top = topLeft.global_position.y
	limit_left = topLeft.global_position.x
	limit_bottom = bottomRight.global_position.y
	limit_right = bottomRight.global_position.x

func _process(_delta):
	var damping = ease(shake_timer.time_left / shake_timer.wait_time, DAMP_EASING) 
	if shake:
		offset = Vector2(
			rand_range(amplitude, -amplitude) * damping,
			rand_range(amplitude, -amplitude) * damping
		)

# This is what should be called to start the screenshake.
func start_shake(_amplitude, _duration):
	amplitude = _amplitude
	duration = _duration
	self.shake = true

func _set_shake(value):
	shake = value 
	offset = Vector2() 
	if shake:
		shake_timer.start()

func _set_duration(value):
	duration = value 
	shake_timer.wait_time = duration


func _on_ShakeTimer_timeout():
	self.shake = false