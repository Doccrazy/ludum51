extends Node3D

@export var projectile: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func fire():
	var shotNode = projectile.instantiate() as RigidBody3D
	var parent = self
	while (!(parent is RigidBody3D)):
		parent = parent.get_parent()
	var velocity = (parent as RigidBody3D).linear_velocity
	shotNode.init(parent, global_transform, velocity)
	get_tree().root.get_child(0).add_child(shotNode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
