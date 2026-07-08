extends Node3D

@export var max_hp: float = 100.0
@export var speed: float = 20.0
@export var damage: float = 1.0

var current_hp: float = max_hp

signal hp_changed(current_hp, max_hp)
signal enemy_died


func _ready() -> void:
	hp_changed.emit(current_hp, max_hp)


func is_alive() -> bool: 
	if current_hp > 0:
		return true
	else:
		return false


func take_damage(amount: float):
	current_hp -= amount
	hp_changed.emit(current_hp, max_hp)
	if current_hp <= 0:
		on_death()
	
	
func on_death():
	var area_node = get_node("Area3D")
	area_node.monitorable = false
	var overlapping_areas = $Area3D.get_overlapping_areas()

	for area in overlapping_areas:
		var area_parent = area.get_parent()
		if area_parent.is_in_group("base_tower"):
			var base_tower_area = area_parent.get_node("Area3D")
			base_tower_area._on_area_3d_area_exited(area_node)
	
	area_node.queue_free()
	enemy_died.emit()
	
