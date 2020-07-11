extends RigidBody2D

# Player controller.

signal player_turn_started()
signal player_turn_taken()
signal player_died()

export var MAX_VELOCITY: Vector2 = Vector2(900, 900)
export var X_IMPULSE_FORCE: Vector2 = Vector2(200, 0)
export var Y_IMPULSE_FORCE: Vector2 = Vector2(0, 200)
export var TURN_COOLDOWN: float = 1.0
export var TURN_DURATION: float = 5.0
var is_player_turn = false

onready var dashDust = $DustContainer/DashDust
onready var turnTimer = $TurnCooldown
onready var hitbox = $Hitbox
onready var hurtbox = $Hurtbox
onready var buttonPrompts = $ButtonPrompts
onready var animationPlayer = $AnimationPlayer

func _ready():
	hitbox.connect("area_entered", self, "_on_hitbox_area_entered")
	hurtbox.connect("body_entered", self, "_on_hurtbox_body_entered")
	hurtbox.connect("area_entered", self, "_on_hurtbox_area_entered")
	turnTimer.connect("timeout", self, "_on_turnTimer_timeout")

func _physics_process(delta):
	buttonPrompts.global_rotation = 0
	if Input.is_action_just_pressed("left_shift") and turnTimer.is_stopped() and !is_player_turn:
		is_player_turn = true
		animationPlayer.play("button_reveal")
		emit_signal("player_turn_started")
	linear_velocity.x = clamp(linear_velocity.x, -MAX_VELOCITY.x, MAX_VELOCITY.x)
	linear_velocity.y = clamp(linear_velocity.y, -MAX_VELOCITY.y, MAX_VELOCITY.y)
	if is_player_turn:
		if Input.is_action_just_pressed("move_left"):
			linear_velocity = Vector2.ZERO
			apply_impulse(Vector2(), -X_IMPULSE_FORCE)
			dashDust.global_position = self.global_position
			dashDust.emitting = true
			dashDust.gravity = Vector2(100, 0)
			_end_turn()

		if Input.is_action_just_pressed("move_right"):
			linear_velocity = Vector2.ZERO
			apply_impulse(Vector2(), X_IMPULSE_FORCE)
			dashDust.global_position = self.global_position
			dashDust.emitting = true
			dashDust.gravity = Vector2(-100, 0)
			_end_turn()

		if Input.is_action_just_pressed("move_up"):
			linear_velocity = Vector2.ZERO
			apply_impulse(Vector2(), -Y_IMPULSE_FORCE)
			dashDust.global_position = self.global_position
			dashDust.emitting = true
			dashDust.gravity = Vector2(0, 100)
			_end_turn()

		if Input.is_action_just_pressed("move_down"):
			linear_velocity = Vector2.ZERO
			apply_impulse(Vector2(), Y_IMPULSE_FORCE)
			dashDust.global_position = self.global_position
			dashDust.emitting = true
			dashDust.gravity = Vector2(0, -100)
			_end_turn()
			

func _end_turn():
	animationPlayer.play_backwards("button_reveal")
	hitbox.set_deferred("monitorable", true)
	hitbox.set_deferred("monitoring", true)
	turnTimer.start(TURN_COOLDOWN)
	is_player_turn = false
	emit_signal("player_turn_taken")

func _on_turnTimer_timeout():
	hitbox.set_deferred("monitorable", false)
	hitbox.set_deferred("monitoring", false)

func _on_hitbox_area_entered(_area):
	apply_impulse(Vector2(), dashDust.gravity * -1)

func _on_hurtbox_body_entered(_body):
	emit_signal("player_died")

func _on_hurtbox_area_entered(_area):
	emit_signal("player_died")
