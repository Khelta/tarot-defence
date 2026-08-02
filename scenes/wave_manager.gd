extends Node
class_name WaveManager

@export var waves : Array[String] = ["3,s,1", "10,s,1;5,s,0.3"]
@export var level_path : Path3D
@export var game_state : GameState
@export var ui : UI

var wave_index : int = 0

var wave_enemy_count : int = 0

var wave_spawn_ended : bool = true

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
			
		if wave_data[1] not in EnemyUtils.dict:
			assert(false, "Second parameter of wave_string must be in enemy_dict")
			
		if not wave_data[2].is_valid_float():
			assert(false, "Third parameter of wave_string must be a float")
			
	return true


func spawn_wave(wave_string: String):
	assert(validate_wave_string(wave_string))

	wave_spawn_ended = false

	var sub_waves = wave_string.split(";")

	for sub_wave in sub_waves:
		var wave_data = sub_wave.split(",")

		var enemy_count = int(wave_data[0])
		var enemy_type = wave_data[1]
		var spawn_delay = float(wave_data[2])

		for x in enemy_count:
			var enemy_instance = EnemyUtils.dict[enemy_type].instantiate()
			add_enemy(enemy_instance)
			await get_tree().create_timer(spawn_delay).timeout
		
		wave_spawn_ended = true


func add_enemy(enemy: BaseEnemy) -> PathFollow3D:
	wave_enemy_count += 1
	
	var path_follow = PathFollow3D.new()
	
	enemy.enemy_died.connect(game_state._change_player_gold)
	enemy.enemy_died.connect(_on_enemy_died)
	enemy.enemy_spawned.connect(add_enemy)
	path_follow.add_child(enemy)
	level_path.add_child(path_follow)
	
	return path_follow


func _on_enemy_died(_v):
	wave_enemy_count -= 1
	if wave_enemy_count == 0 and wave_spawn_ended:
		wave_ended.emit(wave_index, len(waves))
