extends Node

signal anomalyHit

func isSpawning():
	var spawners = get_tree().get_nodes_in_group("spawners")
	for spawner in spawners:
		if spawner.isActive():
			return true
	return false
