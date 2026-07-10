extends Node
class_name WaveManager

@export var waves : Array[String] = ["3,s,1", "10,s,1;5,s,0.3"]
@export var level_path : Path3D
@export var game_state : GameState
@export var ui : UI

var wave_index : int = 0

var skeleton_minion = preload("res://scenes/models/enemies/skeleton_minion.tscn")
var enemy_dict = {"s": skeleton_minion}

var wave_enemy_count : int = 0

signal wave_started(wave_index: int, waves_length: int)
signal wave_ended(wave_index: int, waves_length: int)


func _ready() -> void: 
	assert(level_path != null)
	assert(game_state != null)

	var start_wave_button : StartWaveButton = ui.get_node("StartWaveButton")
	wave_started.connect(start_wave_button._on_wave_started)
	wave_ended.connect(start_wave_button._on_wave_ended)


func next_wave() -> void:
	assert(wave_index < len(waves))
	
	wave_started.emit(wave_index, len(waves))
	spawn_wave(waves[wave_index])
	wave_index += 1


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
		wave_enemy_count += int(wave_data[0])


	for sub_wave in sub_waves:
		var wave_data = sub_wave.split(",")

		var enemy_count = int(wave_data[0])
		var enemy_type = wave_data[1]
		var spawn_delay = float(wave_data[2])

		for x in enemy_count:
			var path_follow = PathFollow3D.new()
			var enemy_instance = enemy_dict[enemy_type].instantiate()
			var base_enemy_of_enemy_instance : BaseEnemy = enemy_instance.get_node("BaseEnemy")
			base_enemy_of_enemy_instance.enemy_died.connect(game_state._change_player_gold)
			base_enemy_of_enemy_instance.enemy_died.connect(_on_enemy_died)
			path_follow.add_child(enemy_instance)
			level_path.add_child(path_follow)
			await get_tree().create_timer(spawn_delay).timeout


func _on_enemy_died(_v):
	wave_enemy_count -= 1
	if wave_enemy_count == 0:
		wave_ended.emit(wave_index, len(waves))
