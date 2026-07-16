extends Node

func get_mouse_world_position() -> Vector3:
	var camera = get_viewport().get_camera_3d()
	var mouse_pos = get_viewport().get_mouse_position()

	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_dir = camera.project_ray_normal(mouse_pos)

	var plane = Plane(Vector3.UP, 0)

	return plane.intersects_ray(ray_origin, ray_dir)

func select_entity_from_mouse(layer_number: int):
	var camera = get_viewport().get_camera_3d()
	var mouse_pos = get_viewport().get_mouse_position()

	# Convert mouse position into a ray
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 1000.0

	# Create ray query
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collide_with_areas = true
	query.collide_with_bodies = false
	
	query.collision_mask = 1 << (layer_number - 1)

	# Perform raycast
	var result = camera.get_world_3d().direct_space_state.intersect_ray(query)

	if result:
		var collider = result.collider
		
		if collider is Area3D:
			return collider.get_parent()

	return null
