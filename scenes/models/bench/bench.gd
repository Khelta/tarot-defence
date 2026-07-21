extends Node3D
class_name Bench

func number_of_free_slots() -> int:
	var result : int = 0

	for bench_slot : BenchSlot in get_children():
		if bench_slot.tower:
			result += 1

	return result


func has_free_slot() -> bool:
	for bench_slot : BenchSlot in get_children():
		if bench_slot.tower == null:
			return true
	return false


func give_next_free_slot() -> BenchSlot:
	for bench_slot : BenchSlot in get_children():
		if bench_slot.tower == null:
			return bench_slot
	return null
