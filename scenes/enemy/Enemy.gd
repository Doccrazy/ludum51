extends RigidBody3D

@export var explosionScene: PackedScene

signal hit

const ROTATE_SPEED = 1.5
const VELOCITY = 10
const TURN_SPEED = 5
const ACCEL = 5
const FIRE_RATE = 0.2
const MAX_HEALTH = 50
const SHOT_SPEED_FOR_EST = 10

var fireCooldown = FIRE_RATE
var health = MAX_HEALTH

# Called when the node enters the scene tree for the first time.
func _ready():
	linear_velocity = global_transform.basis * Vector3(0, 0, -10)
	hit.connect(_on_hit)
	add_to_group("enemies")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var player = get_node_or_null("/root/Root/Player") as RigidBody3D
	if !player:
		return
	
	var dist = (player.global_transform.origin - global_transform.origin).length()
	var projectedOrigin = player.global_transform.origin + player.linear_velocity * (dist/(SHOT_SPEED_FOR_EST + linear_velocity.length()))
	var localDirToPlayer = (projectedOrigin - global_transform.origin) * global_transform.basis
	
	var angle_to_up = Plane(Vector3(0, 0, -1)).project(localDirToPlayer).signed_angle_to(Vector3(0, 1, 0), Vector3(0, 0, -1))
	var angle_to_player = localDirToPlayer.signed_angle_to(Vector3(0, 0, -1), Vector3(-1, 0, 0))

	if linear_velocity.length() < VELOCITY && angle_to_player < 0.5:
		apply_central_force(global_transform.basis * Vector3(0, 0, -ACCEL))
	else: if angle_to_player >= 0.5 && (linear_velocity * global_transform.basis).z < 0:
		apply_central_force(global_transform.basis * Vector3(0, 0, ACCEL*0.1))

	#print(angle_to_up)
	# apply_torque(global_transform.basis * Vector3(TURN_SPEED * sign(angle_to_player), 0, angle_to_up * ROTATE_SPEED))
	var localRotate = Vector3(0, 0, -1).cross(localDirToPlayer.sign()) * ROTATE_SPEED
	localRotate.z = randf() * ROTATE_SPEED
	apply_torque(global_transform.basis * localRotate)
	
	fireCooldown -= delta
	if abs(angle_to_player) < 0.5 && fireCooldown <= 0:
		fireCooldown = FIRE_RATE
		$FireSound.play()
		for weapon in get_node("Weapons").get_children():
			weapon.fire()

func _on_hit(damage: float, cause: Node3D):
	$HitSound.play()
	health -= damage
	if health <= 0:
		var explosion = explosionScene.instantiate()
		explosion.position = global_transform.origin
		$/root/Root.add_child(explosion)
		queue_free()
