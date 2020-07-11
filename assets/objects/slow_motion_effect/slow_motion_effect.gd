extends Node

signal timer_ended()
const END_VALUE: int = 1

var is_active: bool = false
var time_start = null
var duration_ms = null
var start_value = null

func start(duration: float = 0.4, strength: float = 0.9):
	time_start = OS.get_ticks_msec()
	duration_ms = duration * 1000
	start_value = 1 - strength
	Engine.time_scale = start_value
	is_active = true

func _process(_delta):
	if is_active:
		var _current_time = OS.get_ticks_msec() - time_start
		var _value = _circle_ease_int(_current_time, start_value, END_VALUE, duration_ms)
		if _current_time >= duration_ms:
			is_active = false
			_value = END_VALUE
			emit_signal("timer_ended")
		Engine.time_scale = _value
	else:
		Engine.time_scale = 1.0

func _circle_ease_int(_given_time, _start_value, _end_value, _duration_ms):
	_given_time /= _duration_ms
	return -_end_value * (sqrt( 1 - _given_time * _given_time) - 1) + _start_value
