extends Node3D
class_name Projectile

@onready var path : Path3D = $Path3D
@onready var path_follow : PathFollow3D = $Path3D/PathFollow3D

var last_progress_ratio : float = 0.0
var enemy : BaseEnemy


func spawn(tower: BaseTower, local_enemy: BaseEnemy, projectile_scene: PackedScene) -> void:
	enemy = local_enemy
	
	var projectile_instance = projectile_scene.instantiate()
	path_follow.add_child(projectile_instance)
	
	path.curve.add_point(path.to_local(tower.global_position))
	path.curve.add_point(path.to_local(enemy.global_position))


func _process(delta: float) -> void:
	print(path_follow.progress, " | ", path_follow.progress_ratio)
	path_follow.progress += 0.05
	path.curve.set_point_position(1, path.to_local(enemy.global_position))
	if path_follow.progress_ratio >= 1.0 or last_progress_ratio > path_follow.progress_ratio:
		queue_free()
	last_progress_ratio = path_follow.progress_ratio
