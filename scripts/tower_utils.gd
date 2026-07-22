extends Node

func remove_star_level_from_tower_string(tower_string: String) -> String:
	if len(tower_string) > 0:
		if tower_string[-1].is_valid_int():
			tower_string = tower_string.substr(0, tower_string.length() - 1)
	return tower_string

func get_star_level_from_tower_string(tower_string: String) -> int:
	if len(tower_string) > 0:
		if tower_string[-1].is_valid_int():
			return int(tower_string[-1])
	return 1
