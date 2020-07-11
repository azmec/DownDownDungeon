extends Node2D

# The centeral game. Handles signal connections, their effects, sounds, and HUD elements.

var collect_decay: float = 0.5
onready var player = $Player
onready var camera = $Camera2D
onready var slowMotionEffect = $SlowMotionEffect
onready var everythingButPlayer = $EverythingButPlayer
onready var enemyDeathSounds: Array = $Sounds/EnemyDeathSounds.get_children()
onready var collectTimer = $CollectTimer
var coin_sound_pitch = 1.0

func _ready():
	player.connect("player_turn_started", self, "_on_player_turn_started")
	player.connect("player_turn_taken", self, "_on_player_turn_taken")
	player.connect("player_died", self, "_on_player_died")
	slowMotionEffect.connect("timer_ended", self, "_on_slowMotionEffect_timer_ended")
	var enemies = get_tree().get_nodes_in_group("enemies")
	var coins = get_tree().get_nodes_in_group("coins")
	for enemy in enemies:
		enemy.connect("an_enemy_died", self, "_on_an_enemy_died")
	for coin in coins:
		coin.connect("coin_collected", self, "_on_coin_collected")
	

func _physics_process(_delta):
	if collectTimer.is_stopped():
		coin_sound_pitch = 1.0

func _on_player_turn_started():
	player.is_player_turn = true
	everythingButPlayer.modulate = Color(0.6, 0.6, 0.6)
	slowMotionEffect.start(player.TURN_DURATION, 0.7)

func _on_player_turn_taken():
	var _random_pitch = rand_range(1.0, 2.5)
	$Sounds/Blast.pitch_scale = _random_pitch
	$Sounds/Blast.play()
	camera.start_shake(1.0, 0.2)
	player.is_player_turn = false
	slowMotionEffect.is_active = false
	everythingButPlayer.modulate = Color(1, 1, 1)

func _on_player_died():
	$Sounds/OnHit.play()
	SceneChanger.change_scene(get_tree().current_scene.filename, 0.2)

func _on_slowMotionEffect_timer_ended():
	player._end_turn()

func _on_an_enemy_died():
	OS.delay_msec(30)
	$Sounds/OnHit.play()
	var index = randi() % enemyDeathSounds.size() - 1
	enemyDeathSounds[index].play()
	camera.start_shake(8.0, 0.8)

func _on_coin_collected(_value):
	collectTimer.start(collect_decay)
	if !collectTimer.is_stopped():
		coin_sound_pitch += 0.5
	$Sounds/Collect.pitch_scale = coin_sound_pitch
	$Sounds/Collect.play()
