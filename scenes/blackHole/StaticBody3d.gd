extends StaticBody3D

signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	hit.connect(_on_hit)

func _on_hit(damage: float, cause: RigidBody3D):
	get_parent().emit_signal("hit", damage, cause)
