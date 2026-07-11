extends Node
class_name Selector

var selected_tile :  TowerTile
var ui_selected_tower : String = ""
var custom_ui : UI = null

var selected_tower : BaseTower:
	set(new_selected_tower):
		selected_tower = new_selected_tower
		set_ui_tower_preview(new_selected_tower)

signal placement_mode_changed(is_on: bool)

@export var is_placement_mode : bool = false:
	set(value):
		is_placement_mode = value
		placement_mode_changed.emit(value)

func _ready() -> void:
	custom_ui = get_tree().get_first_node_in_group("ui")
	connect_to_ranger_button()


func connect_to_ranger_button():
		await get_tree().process_frame
		var ranger_button = get_tree().get_first_node_in_group("ranger_button")
		ranger_button.toggled.connect(_on_ranger_button_toggle)


func _on_ranger_button_toggle(toggle_on: bool) -> void:
	is_placement_mode = toggle_on
	if toggle_on:
		ui_selected_tower = "ranger"
	else:
		ui_selected_tower = ""


func set_selected_tile(tile: TowerTile) -> void:
	selected_tile = tile
	try_placement()


func try_placement() -> void:
	if selected_tile.is_placeable and selected_tile.tower == null and ui_selected_tower != "":
		var tower_scene_path: String = "res://scenes/models/towers/" + ui_selected_tower + ".tscn"
		var tower_resource = load(tower_scene_path)
		var new_tower: BaseTower = tower_resource.instantiate()
		var towers = get_tree().get_first_node_in_group("towers")
		towers.add_child(new_tower)
		selected_tile.tower = new_tower
		selected_tower = new_tower


func set_ui_tower_preview(tower: BaseTower) -> void:
	custom_ui.get_node("TowerPreview").texture = tower.get_node("BaseTower/SubViewport").get_texture()
