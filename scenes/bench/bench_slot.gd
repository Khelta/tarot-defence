extends Slot
class_name BenchSlot

func _do_after_set_tower(value: BaseTower) -> void: 
	if tower:
		tower.position = global_position

func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	super._on_area_3d_input_event(_camera, event, _event_position, _normal, _shape_idx)
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var selector : Selector = get_tree().get_first_node_in_group("selector")
			if self.tower:
				selector.grab_tower(self)
			elif self.is_free():
				selector.set_selected_tile(self)
