extends Node3D

signal hit

@export var explosionScene: PackedScene

const MAX_HEALTH = 250
const MIN_SCALE_DIST = 80
const MAX_SCALE_DIST = 40
const REVEAL_DIST = 40
const FULL_REVEAL_DIST = 25

var health = MAX_HEALTH

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("anomalies")
	hit.connect(_on_hit)
	await get_tree().create_timer(randf() * $Timer.wait_time).timeout
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var camera = get_viewport().get_camera_3d()
	var dist = (global_transform.origin - camera.global_transform.origin).length()
	var screenPos = camera.unproject_position(global_transform.origin)
	var screen = get_viewport().get_visible_rect()
	var extScreen = screen.expand(Vector2(-200, -200)).expand(screen.end + Vector2(200, 200))
	if !camera.is_position_behind(global_transform.origin) && extScreen.has_point(screenPos):
		var scaleVal = 1 - 0.5 * clamp((dist - MAX_SCALE_DIST)/(MIN_SCALE_DIST - MAX_SCALE_DIST), 0, 1)
		var strengthVal = clamp((dist - FULL_REVEAL_DIST)/(REVEAL_DIST - FULL_REVEAL_DIST), 0, 1)
		$ColorRect.visible = true
		$ColorRect.position = screenPos - scaleVal*$ColorRect.size/2
		$ColorRect.scale = Vector2(scaleVal, scaleVal)
		$ColorRect.material.set_shader_parameter("strengthMult", strengthVal)
	else:
		$ColorRect.visible = false

func _on_hit(damage: float, cause: Node3D):
	print("hit", health)
	var player = get_node_or_null("/root/Root/Player") as RigidBody3D
	var distToPlayer = (cause.global_transform.origin - global_transform.origin).length()
	if !player || cause != player || distToPlayer > REVEAL_DIST:
		return
	health -= damage
	$HitSound.play()
	Global.anomalyHit.emit()
	if health <= 0:
		var explosion = explosionScene.instantiate()
		explosion.position = global_transform.origin
		$/root/Root.add_child(explosion)
		queue_free()


func _on_timer_timeout():
	$ShockwaveSound.play()
	var player = get_node_or_null("/root/Root/Player") as RigidBody3D
	if player:
		player.onShockwaveHit()
