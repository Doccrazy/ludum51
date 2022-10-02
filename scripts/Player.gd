extends RigidBody3D

signal hit

# Converts mouse movement (pixels) to rotation (radians).
const MOUSE_SENSITIVITY = 0.03
const CONTROLLER_SENSITIVITY = 1

const THRUST_FORWARD = 6
const THRUST_BACK = 0.2
const THRUST_SIDE = 1
const MAX_HEALTH = 200
const SHOCKWAVE_IMPULSE = 0.3;

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
			$FireSound.play()
			for weapon in get_node("Weapons").get_children():
				weapon.fire()
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		constant_torque = global_transform.basis * Vector3( -event.relative.y * MOUSE_SENSITIVITY, -event.relative.x * MOUSE_SENSITIVITY, 0)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Cockpit.rotation = angular_velocity * 0.05
	pass

func _physics_process(delta):
	var movement = Input.get_vector("move_left", "move_right", "move_back", "move_forward")
	var upDown = Input.get_axis("move_down", "move_up")
	apply_central_force(global_transform.basis * Vector3(movement.x * THRUST_SIDE, upDown * THRUST_SIDE, -THRUST_FORWARD*movement.y if movement.y > 0 else THRUST_BACK*movement.y))
	if Input.get_connected_joypads().size() > 0:
		var steer = Input.get_vector("steer_left", "steer_right", "steer_up", "steer_down")
		if abs(steer.x) >= 0.01 || abs(steer.y) >= 0.01:
			constant_torque = global_transform.basis * Vector3(-steer.y * CONTROLLER_SENSITIVITY, -steer.x * CONTROLLER_SENSITIVITY, 0)

#func _integrate_forces(state):
#	var localAngular = angular_velocity * global_transform.basis
#	print(localAngular.z)
#	angular_velocity = global_transform.basis * Vector3(localAngular.x, localAngular.y, localAngular.z * 0.9)

func _on_hit(damage: float, cause: Node3D):
	get_node("Camera").shake(damage/MAX_HEALTH)
	$HitSound.play()
	health -= damage
	if health <= 0:
		get_tree().change_scene_to_file("res://scenes/menu/death.tscn")
		pass

func onShockwaveHit():
	$/root/Root/UI/DistortionOverlay.showOverlay()
	apply_torque_impulse(Vector3((randf() - 0.5) * SHOCKWAVE_IMPULSE, (randf() - 0.5) * SHOCKWAVE_IMPULSE, (randf() - 0.5) * SHOCKWAVE_IMPULSE))

func getHealth():
	return health / MAX_HEALTH

func getSpeed():
	return clamp(linear_velocity.length() / 25, 0, 1)
