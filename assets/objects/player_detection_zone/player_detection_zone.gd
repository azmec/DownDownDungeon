extends Area2D

# An area2D that detects and logs the player. 

var player = null

func _ready():
	self.connect("body_entered", self, "_on_PlayerDetectionZone_body_entered")
	self.connect("body_exited", self, "_on_PlayerDetectionZone_body_exited")

func can_see_player():
	return player != null

func _on_PlayerDetectionZone_body_entered(body):
	player = body

func _on_PlayerDetectionZone_body_exited(_body):
	player = null