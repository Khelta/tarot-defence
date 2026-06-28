@tool
extends Node3D

@export var is_placeable: bool = true:
	set(new_is_placeable):
		is_placeable = new_is_placeable
		set_material()
@export var tower: Node3D

func _ready() -> void:
	set_material()
	set_valid_tower_position_vfx_visibility(false)
	connect_to_game_state()
	
		
func connect_to_game_state():
	await get_tree().process_frame
	var game_state = get_tree().get_first_node_in_group("game_state")
	if game_state:
		game_state.placement_mode_changed.connect(_on_game_state_placement_mode_changed)

func set_material() -> void:
	const default_material = null
	const non_placeable_material = preload("res://materials/invalid_placeable_material.tres")
	var floor_mesh = get_node("FloorDirt")
	
	if is_placeable:
		floor_mesh.set_surface_override_material(0, default_material)
	else:
		floor_mesh.set_surface_override_material(0, non_placeable_material)


func is_valid_placement() -> bool:
	if is_placeable:
		return true
	return false


func set_valid_tower_position_vfx_visibility(is_visible : bool) -> void:
	var vfx = get_node("ValidTowerPositionVFX")
	vfx.visible = is_visible


func _on_game_state_placement_mode_changed(placement_mode_is_on: bool) -> void:
	var validTowerPositionVFX = get_node("ValidTowerPositionVFX")
	if placement_mode_is_on and is_valid_placement():
		validTowerPositionVFX.visible = true
	else:
		validTowerPositionVFX.visible = false
