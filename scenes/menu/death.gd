extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("fire") || event.is_action_pressed("ui_select"):
		_on_try_again_button_pressed()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_try_again_button_pressed():
	get_tree().change_scene_to_file("res://game.tscn")
