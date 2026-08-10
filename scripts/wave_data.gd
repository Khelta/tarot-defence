class_name WaveData

var enemy_count: int
var enemy_type: String
var spawn_delay: float

func _init(count: int, type: String, delay: float):
	enemy_count = count
	enemy_type = type
	spawn_delay = delay
