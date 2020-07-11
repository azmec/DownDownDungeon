extends Control

# Handles the actual changing of scenes on button pressing 
# the title screen

onready var buttons = $Menu/CenterRow/Buttons

func _ready():
	for button in buttons.get_children():
		button.connect("pressed", self, "_on_button_pressed", [button.scene_to_load])

func _on_button_pressed(scene_to_load):
	get_tree().change_scene(scene_to_load)