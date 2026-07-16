extends Node
class_name Selector

var selected_tile :  Slot
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
var tower_panel : TowerPanel

@export var grabbed_tower : BaseTower:
	set(new_grabbed_tower):
		if grabbed_tower:
			grabbed_tower._on_grabbed_changed(false)
		grabbed_tower = new_grabbed_tower
		if grabbed_tower:
			grabbed_tower._on_grabbed_changed(true)

@export var is_placement_mode : bool = false:
	set(value):
		is_placement_mode = value
		placement_mode_changed.emit(value)

signal placement_mode_changed(is_on: bool)

func _ready() -> void:
	custom_ui = get_tree().get_first_node_in_group("ui")
	tower_panel = custom_ui.get_node("TowerPanel")
	connect_to_buttons()


func _process(_delta: float) -> void:
	if grabbed_tower:
		grabbed_tower.global_position = MouseUtils.get_mouse_world_position()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("deselect"):
		deselect()


func connect_to_buttons() -> void:
	await get_tree().process_frame
	var ranger_button = get_tree().get_first_node_in_group("ranger_button")
	ranger_button.toggled.connect(_on_unit_button_toggle.bind("ranger"))
	
	var knight_button = get_tree().get_first_node_in_group("knight_button")
	knight_button.toggled.connect(_on_unit_button_toggle.bind("knight"))
	
	var delete_button = get_tree().get_first_node_in_group("delete_button")
	delete_button.pressed.connect(_on_delete_button_pressed)


func _on_unit_button_toggle(toggle_on: bool, selected_tower: String) -> void:
	is_placement_mode = toggle_on
	if toggle_on:
		ui_selected_tower = selected_tower
	else:
		ui_selected_tower = ""


func _on_delete_button_pressed() -> void:
	var delete_tower = selected_tower
	selected_tower = null
	delete_tower.destroy()


func set_selected_tile(tile: Slot) -> void:
	selected_tile = tile
	try_placement()
	is_placement_mode = false


func set_selected_tower(slot: Slot) -> void:
	selected_tower = slot.tower
	tower_panel.visible = true
	tower_panel.connect_tower(selected_tower)


func grab_tower(slot: Slot) -> void:
	selected_tower = null
	selected_tile = slot
	
	if grabbed_tower:
		var temp_tower = slot.tower
		slot.tower = grabbed_tower
		grabbed_tower = temp_tower
	else:
		grabbed_tower = slot.tower
		slot.tower = null
	
	is_placement_mode = true


func deselect() -> void:
	if selected_tile and grabbed_tower:
		selected_tile.tower = grabbed_tower
		grabbed_tower = null
		selected_tile = null
		is_placement_mode = false
		return
	
	if selected_tower:
		selected_tower = null
		selected_tile = null
		is_placement_mode = false
	
	tower_panel.visible = false



func try_placement() -> void:
	if selected_tile.is_free():
		var temp = grabbed_tower
		grabbed_tower = null
		selected_tile.tower = temp


func set_ui_tower_preview(tower: BaseTower) -> void:
	custom_ui.get_node("TowerPreview").texture = tower.get_node("BaseTower/SubViewport").get_texture() if tower else null


func set_fresnel_selection(tower: BaseTower, is_on) -> void:
	tower.get_node("Model")._set_selection(is_on)
