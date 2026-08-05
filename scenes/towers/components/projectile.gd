extends Node3D
class_name Projectile

@onready var path : Path3D = $Path3D
@onready var path_follow : PathFollow3D = $Path3D/PathFollow3D

var particle_effect : PackedScene
var particle_instance : ProjectileEffect

var last_progress_ratio : float = 0.0
var enemy : BaseEnemy

var projectile_speed : float = 0.25
var projectile_height : float = 3.0

signal projectile_hitted(enemy: BaseEnemy)

func _init(_particle_effect: PackedScene = null) -> void:
	if _particle_effect:
		particle_effect = particle_effect

func spawn(tower: BaseTower,
		   local_enemy: BaseEnemy,
		   projectile_mesh_scene: PackedScene,
		   projectile_mesh_rotation_degrees: Vector3,
		   _projectile_speed,
		   _projectile_height,
		   _particle_effect) -> void:

	enemy = local_enemy
	projectile_speed = _projectile_speed
	projectile_height = _projectile_height
	particle_effect = _particle_effect

	var projectile_instance = projectile_mesh_scene.instantiate()
	projectile_instance.rotation_degrees = projectile_mesh_rotation_degrees 
	path_follow.add_child(projectile_instance)

	var height = Vector3(0, projectile_height, 0)
	path.curve.add_point(path.to_local(tower.global_position), Vector3(0, 0, 0), height)
	path.curve.add_point(path.to_local(enemy.global_position), height)
	
	if _particle_effect:
		particle_instance = particle_effect.instantiate()
		projectile_instance.add_child(particle_instance)


func _process(delta: float) -> void:
	path_follow.progress += projectile_speed

	# Update curve to enemy position
	path.curve.set_point_position(1, path.to_local(enemy.global_position))

	if path_follow.progress_ratio >= 1.0 or last_progress_ratio > path_follow.progress_ratio:
		projectile_hitted.emit(enemy)
		destroy()

	var velocity = path_follow.transform.basis.z.normalized() * projectile_speed
	particle_instance.set_projectile_velocity(velocity)

	last_progress_ratio = path_follow.progress_ratio


func destroy() -> void:
	queue_free()
