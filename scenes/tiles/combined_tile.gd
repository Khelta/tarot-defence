extends Node3D
class_name CombinedTile

func update_tower(tower_index, is_eligible):
	if not is_node_ready():
		await ready
	var tower : TowerTile = get_child(tower_index)
	tower.is_eligible = is_eligible
