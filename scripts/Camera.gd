extends Camera3D

const SHAKE_SCALE = 0.3

var shakeIntensity = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shakeIntensity > 0:
		set_rotation(Vector3(randf() * shakeIntensity * SHAKE_SCALE, randf() * shakeIntensity * SHAKE_SCALE, randf() * shakeIntensity * SHAKE_SCALE))
		shakeIntensity -= delta
	pass

func shake(amount: float):
	shakeIntensity += amount
