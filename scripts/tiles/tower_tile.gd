@tool
extends Slot
class_name TowerTile

@export var is_part_of_another_node: bool = false


func _do_after_set_is_eligible(value: bool) -> void:
	super._do_after_set_is_eligible(value)
	set_material()
	$Area3D.input_ray_pickable = value


func _do_after_set_tower(tower: BaseTower) -> void: 
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

func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	super._on_area_3d_input_event(_camera, event, _event_position, _normal, _shape_idx)
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var selector : Selector = get_tree().get_first_node_in_group("selector")
			if self.tower:
				selector.set_selected_tower(self)
			elif self.is_free():
				selector.set_selected_tile(self)
