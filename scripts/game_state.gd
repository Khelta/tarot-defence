extends Node

@export var path : Path3D


func _ready() -> void:
	add_to_group("game_state")


func _process(delta):
	var path_length: float = get_child(0).curve.get_baked_length()
	var enemy_speed = 20
	var time_for_path = path_length * enemy_speed
	var progress_ratio_speed = 100 / time_for_path
	
	for enemy in path.get_children():
		if enemy.get_child(0).get_child(0).is_alive():
			enemy.progress_ratio += progress_ratio_speed * delta
