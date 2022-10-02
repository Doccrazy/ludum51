extends Area3D

@export var asteroidScene: PackedScene
@export var amount: int
@export var minSize = 0.5
@export var maxSize = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("spawn")

func spawn():
	for n in amount:
		var asteroid = asteroidScene.instantiate() as Node3D
		var position = Helpers.random_point_in_area(self, true)
		asteroid.position = transform * position
		asteroid.scale = Vector3(randf()*(maxSize - minSize) + minSize, randf()*(maxSize - minSize) + minSize, randf()*(maxSize - minSize) + minSize)
		asteroid.rotation = Helpers.random_direction()
		get_parent().add_child(asteroid)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
