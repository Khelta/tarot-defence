@tool
extends Node3D
class_name TowerTile

@export var is_part_of_another_node: bool = false

@export var is_placeable: bool = true:
	set(new_is_placeable):
		is_placeable = new_is_placeable
		set_material()
		$Area3D.input_ray_pickable = is_placeable


@export var tower: Node3D:
	set(new_tower):
		tower = new_tower
		tower.position = global_position
		tower.rotation.y = atan2(tower_rotation.x, tower_rotation.z)
		if is_part_of_another_node:
			tower.rotate_y(get_parent().rotation.y)
		set_valid_tower_position_vfx_visibility(false)
		
@export var tower_rotation: Vector3 = Vector3(1, 0, 0):
	set(new_tower_rotation):
		tower_rotation = new_tower_rotation

func _ready() -> void:
	set_material()
	set_valid_tower_position_vfx_visibility(false)
	connect_to_selector()


func connect_to_selector():
	await get_tree().process_frame
	var selector : Selector = get_tree().get_first_node_in_group("selector")
	if selector:
		selector.placement_mode_changed.connect(_on_placement_mode_changed)


func set_material() -> void:
	const default_material = null
	const non_placeable_material = preload("res://materials/invalid_placeable_material.tres")
	var floor_mesh = get_node("FloorDirt")
	
	if is_placeable:
		floor_mesh.set_surface_override_material(0, default_material)
	else:
		floor_mesh.set_surface_override_material(0, non_placeable_material)


func is_valid_placement() -> bool:
	if is_placeable and tower == null:
		return true
	return false


func set_valid_tower_position_vfx_visibility(vfx_is_visible : bool) -> void:
	var vfx = get_node("ValidTowerPositionVFX")
	vfx.visible = vfx_is_visible


func _on_placement_mode_changed(placement_mode_is_on: bool) -> void:
	var validTowerPositionVFX = get_node("ValidTowerPositionVFX")
	if placement_mode_is_on and is_valid_placement():
		validTowerPositionVFX.visible = true
	else:
		validTowerPositionVFX.visible = false


func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	print(_event_position, self)
	if event is InputEventMouseButton and event.pressed:
		var selector = get_tree().get_first_node_in_group("selector")
		selector.set_selected_tile(self)
