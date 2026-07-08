@tool
extends Node3D
class_name BaseTower

@export var tower_range : float = 5.0
@export var base_damage : float = 10.0
@export var attacks_per_second : float = 1.0

var enemies_in_range : Array[Area3D] = []
var attack_cooldown: float = 0.0
const default_timeout = 0.5
var default_rotation = Vector3()

signal attack

func _ready() -> void:
	get_child(0).get_child(0).shape.radius = tower_range
	get_child(1).mesh.radius = tower_range
	get_child(1).mesh.height = tower_range * 2
	
	set_attack_range_indicator()
	
	default_rotation = get_parent().rotation
	
	
func apply_damage(target: Node3D):
	target.take_damage(base_damage) 
	
func _process(delta):
	attack_cooldown -= delta
	if attack_cooldown <= 0.0:
		if len(enemies_in_range) != 0:
			apply_damage(enemies_in_range[0].get_parent())
			attack.emit()
			attack_cooldown = 1.0 / attacks_per_second


func set_attack_range_indicator():
	var attack_range_indicator = get_node("AttackRangeIndicator")
	var s = tower_range * 2
	attack_range_indicator.scale = Vector3(s, s, s)


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.get_parent().name == "BaseEnemy":
		enemies_in_range.push_back(area)


func _on_area_3d_area_exited(area: Area3D) -> void:
	if area.get_parent().name == "BaseEnemy":
		enemies_in_range.erase(area)
