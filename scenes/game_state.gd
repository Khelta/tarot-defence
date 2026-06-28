extends Node

signal placement_mode_changed(is_on: bool)

@export var is_placement_mode : bool = false:
	set(value):
		is_placement_mode = value
		placement_mode_changed.emit(value)


func _ready() -> void:
	add_to_group("game_state")
	connect_to_ranger_button()


func connect_to_ranger_button():
		await get_tree().process_frame
		var ranger_button = get_tree().get_first_node_in_group("ranger_button")
		ranger_button.toggled.connect(_on_ranger_button_toggle)


func _on_ranger_button_toggle(toggle_on: bool) -> void:
	is_placement_mode = toggle_on


func _process(delta):
	var path_length: float = get_child(0).curve.get_baked_length()
	var enemy_speed = 20
	var time_for_path = path_length * enemy_speed
	var progress_ratio_speed = 100 / time_for_path
	get_child(0).get_child(0).progress_ratio += progress_ratio_speed * delta
