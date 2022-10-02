extends RigidBody3D

const DAMAGE = 20;
const VELOCITY = 20;

var parentNode: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(5.0).timeout
	free()

func init(parent: Node3D, xform: Transform3D, velocity: Vector3):
	parentNode = parent
	global_transform = xform
	linear_velocity = velocity + xform.basis * Vector3(0, 0, -VELOCITY)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_3d_body_entered(body: Node3D):
	if body != parentNode:
		body.emit_signal("hit", DAMAGE, parentNode)
		queue_free()
