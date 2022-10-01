extends Area3D

@export var enemyScene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_timer_timeout()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	var enemy = enemyScene.instantiate() as Node3D
	var box = get_node("CollisionShape3d").transform.basis * (get_node("CollisionShape3d").shape.size / 2)
	var origin = get_node("CollisionShape3d").to_global(Vector3(0, 0, 0))
	enemy.position = Vector3(randf_range(origin.x - box.x, origin.x + box.x), randf_range(origin.y - box.y, origin.y + box.y), randf_range(origin.z - box.z, origin.z + box.z))
	enemy.rotation = Vector3(randf() * PI, randf() * PI, randf() * PI)
	owner.add_child(enemy)
