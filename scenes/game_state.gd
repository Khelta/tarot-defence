extends Node

func _ready() -> void:
	var path_length: float = get_child(0).curve.get_baked_length()
	var enemy_speed = 20
	var time_for_path = path_length * enemy_speed
	var progress_ratio_speed = 100 / time_for_path


func _process(delta):
	var path_length: float = get_child(0).curve.get_baked_length()
	var enemy_speed = 20
	var time_for_path = path_length * enemy_speed
	var progress_ratio_speed = 100 / time_for_path
	get_child(0).get_child(0).progress_ratio += progress_ratio_speed * delta
