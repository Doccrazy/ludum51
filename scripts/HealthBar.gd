extends TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = get_node_or_null("/root/Root/Player") as RigidBody3D
	if !player:
		value = 0
		return
	value = player.getHealth() * 100
