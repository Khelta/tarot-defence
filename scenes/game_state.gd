extends Node

func _process(delta):
	get_child(0).get_child(0).progress_ratio += 0.1 * delta
