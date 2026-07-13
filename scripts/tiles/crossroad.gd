@tool
extends CombinedTile


@export var is_tower_one_placeable: bool = true:
	set(new_is_tower_one_placeable):
		is_tower_one_placeable = new_is_tower_one_placeable
		update_tower(0, is_tower_one_placeable)


@export var is_tower_two_placeable: bool = true:
	set(new_is_tower_two_placeable):
		is_tower_two_placeable = new_is_tower_two_placeable
		update_tower(1, is_tower_two_placeable)


@export var is_tower_three_placeable: bool = true:
	set(new_is_tower_three_placeable):
		is_tower_three_placeable = new_is_tower_three_placeable
		update_tower(2, is_tower_three_placeable)


@export var is_tower_four_placeable: bool = true:
	set(new_is_tower_four_placeable):
		is_tower_four_placeable = new_is_tower_four_placeable
		update_tower(3, is_tower_four_placeable)
