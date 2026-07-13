extends Slot
class_name BenchSlot

func _do_after_set_tower(value: BaseTower) -> void: 
	if tower:
		tower.position = global_position

func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	super._on_area_3d_input_event(_camera, event, _event_position, _normal, _shape_idx)
