extends CanvasLayer

# Changes scene when called by fading to background color and 
# reversing once scene is loaded.

signal scene_changed()

onready var animationPlayer = $AnimationPlayer
onready var rect = $Control/ColorRect

func _ready():
	rect.hide()
func change_scene(path: String, delay: float = 0.5):
	rect.show()
	yield(get_tree().create_timer(delay), "timeout")
	animationPlayer.play("fade")
	yield(animationPlayer, "animation_finished")
	get_tree().change_scene(path)
	animationPlayer.play_backwards("fade")
	yield(animationPlayer, "animation_finished")
	rect.hide()
