extends Node
class_name Selector

var ui_selected_tower : String = ""
var custom_ui : UI = null

# Selection for tower_panel
var selected_slot_for_panel : Slot:
	set(value):
		if selected_slot_for_panel:
			set_fresnel_selection(selected_slot_for_panel.tower, false)
		selected_slot_for_panel = value
		if value:
			set_fresnel_selection(value.tower, true)
		set_ui_tower_preview(value.tower if value else null)
var tower_panel : TowerPanel

var grabbed_tower : BaseTower:
	set(new_grabbed_tower):
		if grabbed_tower:
			grabbed_tower._on_grabbed_changed(false)
		grabbed_tower = new_grabbed_tower
		if grabbed_tower:
			grabbed_tower._on_grabbed_changed(true)
var grabbed_tower_slot : Slot

var holding : bool = false
var hold_completed : bool = false
var hold_time : float = 0.3
var hold_timer : float = 0.0

@export var is_placement_mode : bool = false:
	set(value):
		is_placement_mode = value
		placement_mode_changed.emit(value)

signal placement_mode_changed(is_on: bool)

func _ready() -> void:
	custom_ui = get_tree().get_first_node_in_group("ui")
	tower_panel = custom_ui.get_node("TowerPanel")
	connect_to_buttons()


func _process(delta: float) -> void:
	if grabbed_tower:
		grabbed_tower.global_position = MouseUtils.get_mouse_world_position()

	if holding:
		hold_timer += delta
	if hold_timer >= hold_time:
		hold_completed = true


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("tower_info"):
		var slot = MouseUtils.select_entity_from_mouse(3)

		if slot:
			if slot.tower != null:
				if selected_slot_for_panel == null:
					set_selected_tower_from_slot(slot)
				else:
					deselect()
		else:
			deselect()

	if event.is_action_pressed("deselect"):
		deselect()

	if event.is_action_pressed("select"):
		var slot = MouseUtils.select_entity_from_mouse(3)
		hold_started()
		tower_input(slot)


	if event.is_action_released("select"):
		var slot = MouseUtils.select_entity_from_mouse(3)
		
		if holding and hold_completed:
			tower_input(slot)
		reset_hold()


func connect_to_buttons() -> void:
	await get_tree().process_frame
	var ranger_button = get_tree().get_first_node_in_group("ranger_button")
	ranger_button.toggled.connect(_on_unit_button_toggle.bind("ranger"))
	
	var knight_button = get_tree().get_first_node_in_group("knight_button")
	knight_button.toggled.connect(_on_unit_button_toggle.bind("knight"))
	
	var delete_button = get_tree().get_first_node_in_group("delete_button")
	delete_button.pressed.connect(_on_delete_button_pressed)


func _on_unit_button_toggle(toggle_on: bool, _selected_tower: String) -> void:
	is_placement_mode = toggle_on
	if toggle_on:
		ui_selected_tower = _selected_tower
	else:
		ui_selected_tower = ""


func _on_delete_button_pressed() -> void:
	var delete_tower = selected_slot_for_panel.tower
	selected_slot_for_panel = null
	delete_tower.destroy()


func place_grabbed_tower_in_slot(slot: Slot) -> void:
	try_placement(slot)
	is_placement_mode = false


func set_selected_tower_from_slot(slot: Slot) -> void:
	deselect()
	selected_slot_for_panel = slot
	tower_panel.visible = true
	tower_panel.connect_tower(selected_slot_for_panel.tower)


func grab_tower(slot: Slot) -> void:	
	# Already grabbed a tower
	if grabbed_tower:
		var temp_tower = slot.tower
		slot.tower = grabbed_tower
		grabbed_tower_slot.tower = temp_tower
		
		grabbed_tower = null
		grabbed_tower_slot = null
		
		is_placement_mode = false
	
	# No tower has been grabbed yet
	else:
		grabbed_tower = slot.tower
		grabbed_tower_slot = slot
		slot.tower = null
	
		is_placement_mode = true


func deselect() -> void:
	if selected_slot_for_panel:
		selected_slot_for_panel = null
		
	is_placement_mode = false
	tower_panel.visible = false


func try_placement(slot: Slot) -> void:
	if slot.is_free():
		slot.tower = grabbed_tower
		grabbed_tower = null


func set_ui_tower_preview(tower: BaseTower) -> void:
	custom_ui.get_node("TowerPreview").texture = tower.get_node("BaseTower/SubViewport").get_texture() if tower else null


func set_fresnel_selection(tower: BaseTower, is_on) -> void:
	tower.get_node("Model")._set_selection(is_on)


func hold_started() -> void:
	holding = true
	hold_timer = 0.0
	hold_completed = false


func reset_hold() -> void:
	holding = false
	hold_timer = 0.0
	hold_completed = false


func tower_input(slot: Slot):
	if slot is BenchSlot:
		if slot.tower:
			grab_tower(slot)
		elif slot.is_free():
			place_grabbed_tower_in_slot(slot)
				
	if slot is TowerTile:
		if grabbed_tower:
			place_grabbed_tower_in_slot(slot)
