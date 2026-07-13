extends Node

func get_mouse_world_position() -> Vector3:
	var camera = get_viewport().get_camera_3d()
	var mouse_pos = get_viewport().get_mouse_position()

	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_dir = camera.project_ray_normal(mouse_pos)

	var plane = Plane(Vector3.UP, 0)

	return plane.intersects_ray(ray_origin, ray_dir)
