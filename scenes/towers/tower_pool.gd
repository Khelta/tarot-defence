extends Resource
class_name TowerPool

@export var towers: Array[TowerData]

func draw_weighted() -> TowerData:
	var total_weight : float = 0.0

	for tower in towers:
		total_weight += tower.weight

	var roll = randf() * total_weight

	for tower in towers: 
		roll -= tower.weight
		if roll <= 0:
			return tower

	return towers.back()
