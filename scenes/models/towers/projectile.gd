extends Node3D
class_name Projectile

@onready var path : Path3D = $Path3D
@onready var path_follow : PathFollow3D = $Path3D/PathFollow3D

var last_progress_ratio : float = 0.0
var enemy : BaseEnemy

var projectile_speed : float = 0.25


func spawn(tower: BaseTower,
		   local_enemy: BaseEnemy,
		   projectile_mesh_scene: PackedScene,
		   projectile_mesh_rotation_degrees: Vector3,
		   _projectile_speed) -> void:

	enemy = local_enemy
	projectile_speed = _projectile_speed

	var projectile_instance = projectile_mesh_scene.instantiate()
	projectile_instance.rotation_degrees = projectile_mesh_rotation_degrees 
	path_follow.add_child(projectile_instance)

	path.curve.add_point(path.to_local(tower.global_position))
	path.curve.add_point(path.to_local(enemy.global_position))


func _process(delta: float) -> void:
	print(path_follow.progress, " | ", path_follow.progress_ratio)
	path_follow.progress += projectile_speed

	# Update curve to enemy position
	path.curve.set_point_position(1, path.to_local(enemy.global_position))

	if path_follow.progress_ratio >= 1.0 or last_progress_ratio > path_follow.progress_ratio:
		destroy()

	last_progress_ratio = path_follow.progress_ratio


func destroy() -> void:
	queue_free()
