extends Node

func random_point_in_area(area: Area3D, local := false):
	var shape = area.get_child(0) as CollisionShape3D
	var point: Vector3
	if (shape.shape is BoxShape3D):
		var box = shape.shape.size / 2
		point = Vector3(randf_range(-box.x, box.x), randf_range(-box.y, box.y), randf_range(-box.z, box.z))
	if (shape.shape is SphereShape3D):
		point = Vector3(randf() - 0.5, randf() - 0.5, randf() - 0.5).normalized() * shape.shape.radius
		
	if local:
		return shape.transform * point
	else:
		return shape.global_transform * point

func random_direction():
	return Vector3(randf() * PI, randf() * PI, randf() * PI)
