extends Node2D

# Controls the frequency that the parents "wanders"
# and the range in which they can wander.

export var wander_range: int = 32
onready var start_position = self.global_position
onready var target_position = self.global_position
onready var timer = $Timer

func _ready():
	timer.connect("timeout", self, "_on_timer_timeout")
	_update_target_position()

func start_wander_timer(duration):
	timer.start(duration)

func get_time_left():
	return timer.time_left

func _update_target_position():
	var _target_vector: Vector2 = Vector2(rand_range(-wander_range, wander_range), rand_range(-wander_range, wander_range))
	target_position = start_position + _target_vector

func _on_timer_timeout():
	_update_target_position()