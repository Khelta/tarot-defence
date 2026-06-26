@tool
extends Node3D


@export var is_tower_one_placeable: bool = true:
	set(new_is_tower_one_placeable):
		is_tower_one_placeable = new_is_tower_one_placeable
		update_tower(0, is_tower_one_placeable)


@export var is_tower_two_placeable: bool = true:
	set(new_is_tower_two_placeable):
		is_tower_two_placeable = new_is_tower_two_placeable
		update_tower(1, is_tower_two_placeable)


func update_tower(tower_index, is_placeable):
	if not is_node_ready():
		await ready
	var tower = get_child(tower_index)
	tower.is_placeable = is_placeable
	
func _ready() -> void:
	update_tower(0, is_tower_one_placeable)
	update_tower(1, is_tower_one_placeable)
