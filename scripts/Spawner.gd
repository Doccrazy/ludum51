extends Area3D

@export var enemyScene: PackedScene

const MAX_COUNT = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.anomalyHit.connect(on_start_spawn)
	add_to_group("spawners")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_start_spawn():
	print("Enemy alerted")
	await get_tree().create_timer(randf() * $Timer.wait_time).timeout
	$Timer.start()

func _on_timer_timeout():
	var enemyCount = get_tree().get_nodes_in_group("enemies").size()
	var anomalyCount = get_tree().get_nodes_in_group("anomalies").size()
	if enemyCount > MAX_COUNT || anomalyCount == 0:
		return
	var enemy = enemyScene.instantiate() as Node3D
	var spawnpoint = Helpers.random_point_in_area(self)
	enemy.position = spawnpoint
	enemy.rotation = Helpers.random_direction()
	owner.add_child(enemy)

func isActive():
	return !$Timer.is_stopped()
