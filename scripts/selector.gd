extends Node
class_name Selector

var selected_tile :  TowerTile
var ui_selected_tower : String = ""
var custom_ui : UI = null

var selected_tower : BaseTower:
	set(new_selected_tower):
		if selected_tower:
			set_fresnel_selection(selected_tower, false)
		selected_tower = new_selected_tower
		if new_selected_tower:
			set_fresnel_selection(new_selected_tower, true)
		set_ui_tower_preview(new_selected_tower)
		

signal placement_mode_changed(is_on: bool)

@export var is_placement_mode : bool = false:
	set(value):
		is_placement_mode = value
		placement_mode_changed.emit(value)

func _ready() -> void:
	custom_ui = get_tree().get_first_node_in_group("ui")
	connect_to_ranger_button()
	connect_to_delete_button()


func connect_to_ranger_button() -> void:
		await get_tree().process_frame
		var ranger_button = get_tree().get_first_node_in_group("ranger_button")
		ranger_button.toggled.connect(_on_ranger_button_toggle)


func connect_to_delete_button() -> void:
	await get_tree().process_frame
	var delete_button = get_tree().get_first_node_in_group("delete_button")
	delete_button.pressed.connect(_on_delete_button_pressed)


func _on_ranger_button_toggle(toggle_on: bool) -> void:
	is_placement_mode = toggle_on
	if toggle_on:
		ui_selected_tower = "ranger"
	else:
		ui_selected_tower = ""


func _on_delete_button_pressed() -> void:
	var delete_tower = selected_tower
	selected_tower = null
	delete_tower.destroy()
		


func set_selected_tile(tile: TowerTile) -> void:
	selected_tile = tile
	try_placement()


func set_selected_tower(tower: BaseTower) -> void:
	selected_tower = tower


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
	custom_ui.get_node("TowerPreview").texture = tower.get_node("BaseTower/SubViewport").get_texture() if tower else null


func set_fresnel_selection(tower: BaseTower, is_on) -> void:
	tower.get_node("Model")._set_selection(is_on)
