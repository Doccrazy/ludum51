extends Control

var gameScene = preload("res://game.tscn")
var tmp1 = preload("res://scenes/menu/victory.tscn")
var tmp2 = preload("res://scenes/menu/death.tscn")
var tmp3 = preload("res://scenes/enemy/Enemy.tscn")
var tmp4 = preload("res://scenes/laser/Laser.tscn")
var tmp5 = preload("res://scenes/explosion/Explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_select"):
		_on_start_button_pressed()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_packed(gameScene)


func _on_start_button_fs_pressed():
	get_viewport().mode = Window.MODE_FULLSCREEN
	get_tree().change_scene_to_packed(gameScene)
