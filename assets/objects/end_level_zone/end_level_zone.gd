extends Area2D

export var scene_to_load: String

func _ready():
	self.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(_body):
	SceneChanger.change_scene(scene_to_load)
