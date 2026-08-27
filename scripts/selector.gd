extends Node
class_name Selector

@export var level : Level
var game_state : GameState
var ui : UI

var ui_selected_tower : String = ""

# Selection for tower_panel
var selected_slot_for_panel : Slot:
	set(value):
		if selected_slot_for_panel:
			if selected_slot_for_panel.tower:
				set_fresnel_selection(selected_slot_for_panel.tower, false)
				selected_slot_for_panel.tower.set_selected(false)
		selected_slot_for_panel = value
		if value:
			if value.tower:
				set_fresnel_selection(value.tower, true)
				selected_slot_for_panel.tower.set_selected(true)
		# set_ui_tower_preview(value.tower if value else null)
var tower_panel : TowerPanel

var grabbed_tower : BaseTower
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
	ui = level.ui
	tower_panel = ui.tower_panel
	game_state = level.game_state
	
	var sell_tower_button : SellTowerButton = ui.sell_tower_button
	sell_tower_button.sell_requested.connect(sell_selected)


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
			if slot == selected_slot_for_panel:
				deselect()
			elif slot.tower != null:
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
		grabbed_tower.change_state(BaseTower.State.GRABBED)
	
		is_placement_mode = true


func deselect() -> void:
	if selected_slot_for_panel:
		selected_slot_for_panel = null
		
	is_placement_mode = false
	tower_panel.visible = false


func try_placement(slot: Slot) -> void:
	if slot.is_free():
		slot.tower = grabbed_tower
		var state = BaseTower.State.PLACED if slot.type == "Tile" else BaseTower.State.BENCHED
		set_grabbed_tower(null, state)


func set_grabbed_tower(new_grabbed_tower: BaseTower, state: BaseTower.State = BaseTower.State.BENCHED) -> void:
		if grabbed_tower:
			grabbed_tower.change_state(state)

		grabbed_tower = new_grabbed_tower

		if grabbed_tower:
			grabbed_tower.change_state(BaseTower.State.GRABBED)

func set_ui_tower_preview(tower: BaseTower) -> void:
	ui.get_node("TowerPreview").texture = tower.get_node("BaseTower/SubViewport").get_texture() if tower else null


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


func tower_input(slot: Slot) -> void:
	if slot is BenchSlot:
		if slot.tower:
			grab_tower(slot)
		elif slot.is_free():
			place_grabbed_tower_in_slot(slot)

	if slot is TowerTile:
		if grabbed_tower and slot.is_eligible:
			place_grabbed_tower_in_slot(slot)


func sell_selected() -> void:
	if selected_slot_for_panel:
		if selected_slot_for_panel.tower:
			var sell_value : int = ceili(0.75 * selected_slot_for_panel.tower.get_value())
			game_state._change_player_gold(sell_value)
			selected_slot_for_panel.tower.destroy()
