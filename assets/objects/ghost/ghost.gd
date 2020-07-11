extends KinematicBody2D

# Ghost enemy.

signal an_enemy_died()

enum {
	IDLE, 
	WANDER, 
	CHASE,
	DEAD
}
export var FRICTION: int = 200
export var ACCELERATION: int = 300
export var MAX_SPEED: int = 250
export var WANDER_TARGET_RANGE: int = 4
export var GRAVITY: int = 400

onready var wanderController = $WanderController
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer
onready var hitbox = $Hitbox
onready var hurtbox = $Hurtbox

var velocity: Vector2 = Vector2.ZERO
var state: int = CHASE

func _ready():
	animationPlayer.connect("animation_finished", self, "_on_animation_finished")
	hurtbox.connect("area_entered", self, "_on_hurtbox_area_entered")
	state = _pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	match state:
		IDLE:
			animationPlayer.play("default")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			_seek_player()
			if wanderController.get_time_left() == 0:
				_update_wander()
		WANDER:
			animationPlayer.play("default")
			_seek_player()
			if wanderController.get_time_left() == 0:
				_update_wander()
			_accelerate_towards_point(wanderController.target_position, delta)
			if self.global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				_update_wander()
		CHASE:
			animationPlayer.play("default")
			var _player = playerDetectionZone.player
			if _player != null:
				_accelerate_towards_point(_player.global_position, delta)
			else:
				state = IDLE
		DEAD:
			hitbox.set_deferred("monitorable", false)
			hurtbox.set_deferred("monitoring", false)

	velocity = move_and_slide(velocity)

func _pick_random_state(state_list: Array):
	state_list.shuffle()
	return state_list.pop_front()

func _update_wander():
	state = _pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))

func _seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _accelerate_towards_point(point: Vector2, delta):
	var _direction = self.global_position.direction_to(point)
	velocity = velocity.move_toward(_direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func _on_hurtbox_area_entered(area):
	state = DEAD
	self.velocity = area.get_parent().linear_velocity * -1
	animationPlayer.play("death")
	emit_signal("an_enemy_died")

func _on_animation_finished(anim_name):
	if anim_name == "death":
		call_deferred("free")