extends Node
class_name WaveManager

@export var waves : Array[String] = ["3,s,1", "10,s,1;5,s,0.3"]
@export var game_state : GameState
@export var enemy_wave_preview : EnemyWavePreview

var wave_index : int = 0

var wave_enemy_count : int = 0

var wave_spawn_ended : bool = true

signal wave_started(wave_index: int, waves_length: int)
signal wave_ended(wave_index: int, waves_length: int)


func _ready() -> void: 
	assert(game_state != null)
	assert(enemy_wave_preview != null)
	
	var ui : UI = game_state.ui

	var start_wave_button : StartWaveButton = ui.start_wave_button
	start_wave_button.start_wave_button_pressed.connect(next_wave)
	wave_started.connect(start_wave_button._on_wave_started)
	wave_ended.connect(start_wave_button._on_wave_ended)
	wave_ended.connect(ui.end_screen.on_game_won)

	enemy_wave_preview.set_wave_preview_from_wave_string(waves[0])


func next_wave() -> void:
	assert(wave_index < len(waves))
	
	wave_started.emit(wave_index, len(waves))
	spawn_wave(waves[wave_index])
	wave_index += 1


func spawn_wave(wave_string: String):
	wave_spawn_ended = false

	var sub_waves = wave_string.split(";")

	for sub_wave in sub_waves:
		var wave_data : WaveData = WaveDataUtils.get_wave_data_from_sub_wave_string(sub_wave)

		for x in wave_data.enemy_count:
			var enemy_instance = EnemyUtils.enemy_scenes_dict[wave_data.enemy_type].instantiate()
			add_enemy(enemy_instance)
			await get_tree().create_timer(wave_data.spawn_delay).timeout
		
		wave_spawn_ended = true


func add_enemy(enemy: BaseEnemy) -> PathFollow3D:
	wave_enemy_count += 1
	
	var path_follow = PathFollow3D.new()
	
	enemy.enemy_died.connect(game_state._change_player_gold)
	enemy.enemy_died.connect(_on_enemy_died)
	enemy.enemy_spawned.connect(add_enemy)
	path_follow.add_child(enemy)
	game_state.level_path.add_child(path_follow)
	
	return path_follow


func _on_enemy_died(_v):
	wave_enemy_count -= 1
	if wave_enemy_count == 0 and wave_spawn_ended:
		wave_ended.emit(wave_index, len(waves))

		if wave_index < len(waves):
			enemy_wave_preview.set_wave_preview_from_wave_string(waves[wave_index])

		if wave_index == len(waves):
			game_state.game_won.emit()
