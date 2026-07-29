@tool
extends Slot
class_name TowerTile

@export var is_part_of_another_node: bool = false


func _do_after_set_is_eligible(value: bool) -> void:
	super._do_after_set_is_eligible(value)
	set_material()
	$Area3D.input_ray_pickable = value


func _do_after_set_tower() -> void: 
	if tower:
		tower.position = global_position
		tower.set_viewport_camera(global_position)
		tower.rotation.y = atan2(tower_rotation.x, tower_rotation.z)
		if is_part_of_another_node:
			tower.rotate_y(get_parent().rotation.y)
		set_valid_tower_position_vfx_visibility(false)


func _ready() -> void:
	super._ready()
	set_material()


func set_material() -> void:
	const default_material = null
	const non_placeable_material = preload("res://materials/invalid_placeable_material.tres")
	var floor_mesh = get_node("FloorDirt")
	
	if is_eligible:
		floor_mesh.set_surface_override_material(0, default_material)
	else:
		floor_mesh.set_surface_override_material(0, non_placeable_material)
