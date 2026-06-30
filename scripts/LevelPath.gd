extends Path3D

@export var waves : Array[String] = ["3,s,1", "10,s,1;5,s,0.3"]

var skeleton_minion = preload("res://scenes/models/enemies/skeleton_minion.tscn")
var enemy_dict = {"s": skeleton_minion}


func _ready() -> void: 
	spawn_wave(waves[0])


func validate_wave_string(wave_string: String) -> bool: 
	var sub_waves = wave_string.split(";")
	
	for sub_wave in sub_waves:
		var wave_data = sub_wave.split(",")
		if len(wave_data) != 3:
			assert(false, "Length of sub_wave must be 3")
		
		if not wave_data[0].is_valid_int():
			assert(false, "First parameter of wave_string must be an integer")
			
		if wave_data[1].is_valid_int() or wave_data[1].is_valid_float():
			assert(false, "Second parameter of wave_string must be a String")
			
		if wave_data[1] not in enemy_dict:
			assert(false, "Second parameter of wave_string must be in enemy_dict")
			
		if not wave_data[2].is_valid_float():
			assert(false, "Third parameter of wave_string must be a float")
			
	return true


func spawn_wave(wave_string: String):
	assert(validate_wave_string(wave_string))
	
	var sub_waves = wave_string.split(";")
	
	for sub_wave in sub_waves:
		var wave_data = sub_wave.split(",")
		
		var enemy_count = int(wave_data[0])
		var enemy_type = wave_data[1]
		var spawn_delay = float(wave_data[2])
		
		for x in enemy_count:
			var path_follow = PathFollow3D.new()
			var enemy_instance = enemy_dict[enemy_type].instantiate()
			path_follow.add_child(enemy_instance)
			add_child(path_follow)
			await get_tree().create_timer(spawn_delay).timeout
