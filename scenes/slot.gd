extends Node3D
class_name Slot

@export var is_eligible : bool = false:
	set(value):
		is_eligible = value
		_do_after_set_is_eligible(is_eligible)

@export var tower : BaseTower = null:
	set(value):
		tower = value
		_do_after_set_tower(value)

@export var tower_rotation: Vector3 = Vector3(1, 0, 0):
	set(new_tower_rotation):
		tower_rotation = new_tower_rotation

func _ready():
	connect_to_selector()
	set_valid_tower_position_vfx_visibility(false)


func _do_after_set_tower(new_tower: BaseTower):
	pass


func _do_after_set_is_eligible(value: bool):
	pass


func is_free() -> bool:
	return is_eligible and tower == null


func connect_to_selector():
	await get_tree().process_frame
	var selector : Selector = get_tree().get_first_node_in_group("selector")
	if selector:
		selector.placement_mode_changed.connect(_on_placement_mode_changed)


func set_valid_tower_position_vfx_visibility(vfx_is_visible : bool) -> void:
	var vfx = get_node("ValidTowerPositionVFX")
	vfx.visible = vfx_is_visible


func _on_placement_mode_changed(placement_mode_is_on: bool) -> void:
	if placement_mode_is_on and is_free():
		set_valid_tower_position_vfx_visibility(true)
	else:
		set_valid_tower_position_vfx_visibility(false)


func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	pass
