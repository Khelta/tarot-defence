extends Slot
class_name BenchSlot

func _do_after_set_tower(value: BaseTower) -> void: 
	if tower:
		tower.position = global_position
