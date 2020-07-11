extends Position2D

# Coin object that gravitates towards player when they enter
# the player detection zone.

signal coin_collected(value)

export var value: int = 1
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox

func _ready():
	hurtbox.connect("area_entered", self, "_on_hurtbox_area_entered")

func _physics_process(delta):
	if playerDetectionZone.can_see_player():
		var _player = playerDetectionZone.player
		self.global_position = lerp(self.global_position, _player.global_position, delta)


func _on_hurtbox_area_entered(_area):
	emit_signal("coin_collected", value)
	call_deferred("free")