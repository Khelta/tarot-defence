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

var enemies_in_range : Array[BaseEnemy] = []

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

var tower_effect_manager : TowerEffectManager

enum TargetPriority {
	FIRST,
	LAST,
	LOWEST_HP,
	HIGHEST_HP,
	CLOSEST,
	FARTHEST
}

var target_priority = TargetPriority.FIRST

signal attacked
signal grabbed
signal grab_released
signal stats_updated

var projectile = preload("res://scenes/towers/components/projectile.tscn")
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

	tower_effect_manager = get_node("BaseTower/TowerEffectManager")


func _process(delta):
	attack_cooldown -= delta
	if attack_cooldown <= 0.0 and len(enemies_in_range) != 0 and not is_grabbed:

		var target_enemy : BaseEnemy
		match target_priority:

			TargetPriority.FIRST:
				enemies_in_range.sort_custom(func(a, b): 
					return a.get_parent().progress_ratio < b.get_parent().progress_ratio)
				target_enemy = enemies_in_range[-1]

			TargetPriority.LAST:
				enemies_in_range.sort_custom(func(a, b): 
					return a.get_parent().progress_ratio < b.get_parent().progress_ratio)
				target_enemy = enemies_in_range[0]

			TargetPriority.HIGHEST_HP:
				enemies_in_range.sort_custom(func(a, b): 
					return a.current_hp < b.current_hp)
				target_enemy = enemies_in_range[-1]

			TargetPriority.LOWEST_HP:
				enemies_in_range.sort_custom(func(a, b): 
					return a.current_hp < b.current_hp)
				target_enemy = enemies_in_range[0]

			TargetPriority.CLOSEST:
				enemies_in_range.sort_custom(func(a, b): 
					return abs(global_position - a.global_position) < abs(global_position - b.global_position))
				target_enemy = enemies_in_range[0]

			TargetPriority.FARTHEST:
				enemies_in_range.sort_custom(func(a, b): 
					return abs(global_position - a.global_position) < abs(global_position - b.global_position))
				target_enemy = enemies_in_range[-1]


		if has_projectile:
			spawn_projectile(target_enemy)
		else:
			apply_damage(target_enemy)

		attacked.emit()
		attack_cooldown = 1.0 / (attacks_per_second * tower_effect_manager.get_attack_speed_modifier())


func destroy() -> void:
	queue_free()


func apply_damage(target: BaseEnemy) -> void:
	_apply_target_damage(target)
	_apply_aoe_damage(target)


func _apply_target_damage(target: BaseEnemy, damage = base_damage) -> void:
	damage = damage * tower_effect_manager.get_damage_modifier()

	var target_info = target.take_damage(damage)
	damage_dealt += target_info[0]
	if target_info[1] == true:
		enemies_killed += 1

	stats_updated.emit()


func _apply_aoe_damage(target: BaseEnemy, damage = base_damage) -> void:
	damage = damage * tower_effect_manager.get_damage_modifier()

	if attack_area > 0:
		var shape = SphereShape3D.new()
		shape.radius = attack_area

		var query := PhysicsShapeQueryParameters3D.new()
		query.shape = shape
		query.collide_with_areas = true
		query.collision_mask = 1 << 1
		query.transform = Transform3D(Basis(), target.global_position)
		query.exclude = [self]

		var results = get_world_3d().direct_space_state.intersect_shape(query)

		for result in results:
			var enemy = result["collider"].get_parent().get_parent()
			if enemy != target:
				_apply_target_damage(enemy, damage)


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
		enemies_in_range.push_back(area.get_parent().get_parent())


func _on_area_3d_area_exited(area: Area3D) -> void:
	if area.get_parent().name == "BaseEnemy":
		enemies_in_range.erase(area.get_parent().get_parent())


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


func spawn_projectile(enemy: BaseEnemy) -> void:
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
