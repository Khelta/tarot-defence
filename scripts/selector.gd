extends Node

var selected_tile :  TowerTile
var selected_tower : String
var ui : UI = null

signal placement_mode_changed(is_on: bool)

@export var is_placement_mode : bool = false:
	set(value):
		is_placement_mode = value
		placement_mode_changed.emit(value)

func _ready() -> void:
	var ui = get_tree().get_first_node_in_group("game_state")
	connect_to_ranger_button()


func connect_to_ranger_button():
		await get_tree().process_frame
		var ranger_button = get_tree().get_first_node_in_group("ranger_button")
		ranger_button.toggled.connect(_on_ranger_button_toggle)


func _on_ranger_button_toggle(toggle_on: bool) -> void:
	is_placement_mode = toggle_on
	if toggle_on:
		selected_tower = "ranger"


func set_selected_tile(tile: TowerTile) -> void:
	selected_tile = tile
	try_placement()


func try_placement() -> void:
	if selected_tile.is_placeable and selected_tile.tower == null and selected_tower != "":
		var tower_scene_path: String = "res://scenes/models/towers/" + selected_tower + ".tscn"
		var tower_resource = load(tower_scene_path)
		var new_tower = tower_resource.instantiate()
		var towers = get_tree().get_first_node_in_group("towers")
		towers.add_child(new_tower)
		selected_tile.tower = new_tower
		
		
