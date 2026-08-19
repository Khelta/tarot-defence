extends Node
class_name Level

@export var ui : UI
@export var game_state : GameState
@export var selector : Selector
@export var wave_manager : WaveManager
@export var towers : Towers

func _ready() -> void:
	assert(ui != null)
	assert(game_state != null)
	assert(selector != null)
	assert(wave_manager != null)
	assert(towers != null)
