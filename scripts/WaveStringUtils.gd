extends Node


func get_wave_data_from_sub_wave_string(sub_wave_string: String) -> WaveData:
	if not validate_wave_string(sub_wave_string):
		return null

	var wave_data = sub_wave_string.split(",")

	var enemy_count = int(wave_data[0])
	var enemy_type = wave_data[1]
	var spawn_delay = float(wave_data[2])
	
	return WaveData.new(enemy_count, enemy_type, spawn_delay)


func get_wave_data_from_wave_string(wave_string: String) -> Array[WaveData]:
	var result = []

	for sub_wave_string in wave_string.split(";"):
		result.push_back(get_wave_data_from_sub_wave_string(sub_wave_string))

	return result


func validate_wave_string(wave_string: String) -> bool: 
	var sub_waves = wave_string.split(";")

	for sub_wave in sub_waves:
		var wave_data = sub_wave.split(",")
		if len(wave_data) != 3:
			assert(false, "Length of sub_wave must be 3")
			return false

		if not wave_data[0].is_valid_int():
			assert(false, "First parameter of wave_string must be an integer")
			return false

		if wave_data[1].is_valid_int() or wave_data[1].is_valid_float():
			assert(false, "Second parameter of wave_string must be a String")
			return false

		if wave_data[1] not in EnemyUtils.enemy_scenes_dict:
			assert(false, "Second parameter of wave_string must be in enemy_dict")
			return false

		if not wave_data[2].is_valid_float():
			assert(false, "Third parameter of wave_string must be a float")
			return false

	return true
