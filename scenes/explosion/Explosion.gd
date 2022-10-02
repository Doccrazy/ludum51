extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	$GpuParticles3d.emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !$GpuParticles3d.emitting:
		queue_free()
