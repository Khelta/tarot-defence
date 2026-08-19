extends Node
class_name Level

@export var ui : UI
@export var game_state : GameState
@export var selector : Selector
@export var wave_manager : WaveManager
@export var towers : Towers
@export var level_path : LevelPath
@export var bench : Bench

func _ready() -> void:
	assert(ui != null)
	assert(game_state != null)
	assert(selector != null)
	assert(wave_manager != null)
	assert(towers != null)
	assert(level_path != null)
	assert(bench != null)
