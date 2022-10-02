extends Area3D

@export var enemyScene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("_on_timer_timeout")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	var enemy = enemyScene.instantiate() as Node3D
	var spawnpoint = Helpers.random_point_in_area(self)
	enemy.position = spawnpoint
	enemy.rotation = Helpers.random_direction()
	owner.add_child(enemy)
