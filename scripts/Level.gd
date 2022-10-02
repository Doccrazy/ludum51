extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var enemyCount = get_tree().get_nodes_in_group("enemies").size()
	var anomalyCount = get_tree().get_nodes_in_group("anomalies").size()
	if enemyCount == 0 && anomalyCount == 0:
		get_tree().change_scene_to_file("res://scenes/menu/victory.tscn")
