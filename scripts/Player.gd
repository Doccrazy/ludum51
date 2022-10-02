extends RigidBody3D

signal hit

# Converts mouse movement (pixels) to rotation (radians).
const MOUSE_SENSITIVITY = 0.03

const THRUST_FORWARD = 4
const THRUST_BACK = 0.2
const THRUST_SIDE = 1
const MAX_HEALTH = 100

var health = MAX_HEALTH

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hit.connect(_on_hit)
	#add_constant_torque(global_transform.basis * Vector3(0, 0, 10))

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			get_tree().quit()
	if event.is_action_pressed("fire"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_viewport().set_input_as_handled()
		else:
			for weapon in get_node("Weapons").get_children():
				weapon.fire()
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		constant_torque = global_transform.basis * Vector3( -event.relative.y * MOUSE_SENSITIVITY, -event.relative.x * MOUSE_SENSITIVITY, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if Input.is_action_pressed("forward"):
		apply_central_force(global_transform.basis * Vector3(0, 0, -THRUST_FORWARD))
	if Input.is_action_pressed("back"):
		apply_central_force(global_transform.basis * Vector3(0, 0, THRUST_BACK))
	if Input.is_action_pressed("left"):
		apply_central_force(global_transform.basis * Vector3(-THRUST_SIDE, 0, 0))
	if Input.is_action_pressed("right"):
		apply_central_force(global_transform.basis * Vector3(THRUST_SIDE, 0, 0))
	if Input.is_action_pressed("up"):
		apply_central_force(global_transform.basis * Vector3(0, THRUST_SIDE, 0))
	if Input.is_action_pressed("down"):
		apply_central_force(global_transform.basis * Vector3(0, -THRUST_SIDE, 0))

#func _integrate_forces(state):
#	var localAngular = angular_velocity * global_transform.basis
#	print(localAngular.z)
#	angular_velocity = global_transform.basis * Vector3(localAngular.x, localAngular.y, localAngular.z * 0.9)

func _on_hit(damage: float):
	get_node("Camera").shake(damage/MAX_HEALTH)
	#health -= damage
	if health <= 0:
		queue_free()
