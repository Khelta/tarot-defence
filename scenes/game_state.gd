extends Node

signal placement_mode_changed(is_on: bool)

@export var is_placement_mode : bool = false:
	set(value):
		is_placement_mode = value
		placement_mode_changed.emit(value)



func _ready() -> void:
	add_to_group("game_state")
	print(get_tree().get_first_node_in_group("game_state"))


func _process(delta):
	var path_length: float = get_child(0).curve.get_baked_length()
	var enemy_speed = 20
	var time_for_path = path_length * enemy_speed
	var progress_ratio_speed = 100 / time_for_path
	get_child(0).get_child(0).progress_ratio += progress_ratio_speed * delta
