extends Slot
class_name BenchSlot

func _do_after_set_tower() -> void: 
	if tower:
		tower.position = global_position
