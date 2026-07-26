@tool
extends Node3D
class_name BaseTower

@export var tower_range : float = 5.0
@export var base_damage : float = 10.0
@export var attacks_per_second : float = 1.0
@export var attack_area : float = 0
var damage_dealt : float = 0
var enemies_killed : int = 0

var star_level : int = 1
var base_value : int = 1

var enemies_in_range : Array[Area3D] = []
var attack_cooldown: float = 0.0
const default_timeout = 0.5
var default_rotation = Vector3()
var is_grabbed: bool = false:
	set(new_is_grabbed):
		is_grabbed = new_is_grabbed
		get_node("BaseTower/AttackRangeIndicator").visible = is_grabbed
		if is_grabbed:
			grabbed.emit()
		else:
			grab_released.emit()
var is_selected: bool = false

var attack_range_indicator : MeshInstance3D = null 

signal attacked
signal grabbed
signal grab_released
signal stats_updated

var projectile = preload("res://scenes/models/towers/projectile.tscn")
@export var has_projectile : bool = false
@export var projectile_mesh = preload("res://assets/KayKit_Adventurers_2.0_FREE/Assets/fbx/arrow_bow.fbx")
@export var projectile_mesh_rotation_degrees : Vector3 = Vector3(0.0, 0.0, 0.0)
@export var projectile_speed : float = 0.3
@export var projectile_height : float = 3.0

func _ready() -> void:
	default_rotation = rotation
	
	var area : Area3D = get_node("BaseTower/Area3D")
	area.area_entered.connect(_on_area_3d_area_entered)
	area.area_exited.connect(_on_area_3d_area_exited)
	
	var collision : CollisionShape3D = get_node("BaseTower/Area3D/CollisionShape3D")
	collision.shape = collision.shape.duplicate(true)
	
	attack_range_indicator = get_node("BaseTower/AttackRangeIndicator")
	attack_range_indicator_init()
	
	set_tower_range(tower_range)


func _process(delta):
	attack_cooldown -= delta
	if attack_cooldown <= 0.0 and len(enemies_in_range) != 0 and not is_grabbed:
		var enemy = enemies_in_range[0].get_parent()

		if has_projectile:
			var local_projectile : Projectile = projectile.instantiate()
			add_child(local_projectile)
			local_projectile.spawn(self,
								   enemy,
								   projectile_mesh,
								   projectile_mesh_rotation_degrees,
								   projectile_speed,
								   projectile_height,
								   )
			local_projectile.projectile_hitted.connect(apply_damage)
		else:
			apply_damage(enemy)

		attacked.emit()
		attack_cooldown = 1.0 / attacks_per_second


func destroy() -> void:
	queue_free()


func apply_damage(target: BaseEnemy):
	var target_info = target.take_damage(base_damage)
	damage_dealt += target_info[0]
	if target_info[1] == true:
		enemies_killed += 1
	stats_updated.emit()


func upgrade():
	star_level += 1
	var model = get_node("Model")
	var scale_value = 1 + 0.5 * (star_level - 1)
	model.scale = Vector3(scale_value, scale_value, scale_value)


func attack_range_indicator_init():
	var s = tower_range * 2
	attack_range_indicator.scale = Vector3(s, s, s)


func set_attack_range_indicator_visibility(_is_visible: bool) -> void:
	attack_range_indicator.visible = _is_visible


func set_viewport_camera(camera_position: Vector3) -> void:
	get_node("BaseTower/SubViewport/Camera3D").position = camera_position + Vector3(1.0, 2.0, -1.0)


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.get_parent().name == "BaseEnemy":
		enemies_in_range.push_back(area)


func _on_area_3d_area_exited(area: Area3D) -> void:
	if area.get_parent().name == "BaseEnemy":
		enemies_in_range.erase(area)


func _on_grabbed_changed(_is_grabbed: bool) -> void:
	self.is_grabbed = _is_grabbed


func set_selected(value: bool):
	is_selected = value
	set_attack_range_indicator_visibility(is_selected)


func set_tower_range(value: float) -> void: 
	tower_range = value
	get_node("BaseTower/Area3D/CollisionShape3D").shape.radius = tower_range
	get_node("BaseTower/DebugMesh").mesh.radius = tower_range
	get_node("BaseTower/DebugMesh").mesh.height = tower_range * 2


func get_value() -> int:
	return base_value
