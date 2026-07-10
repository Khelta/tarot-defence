extends Button
class_name StartWaveButton

var wave_manager: WaveManager = null

func _ready() -> void:
	var game_state : GameState = get_tree().get_first_node_in_group("game_state")
	wave_manager = game_state.get_node("WaveManager")


func _on_wave_started(wave_index: int, waves_length: int) -> void:
	visible = false


func _on_wave_ended(wave_index: int, waves_length: int) -> void:
	if wave_index <= waves_length - 1:
		visible = true


func _on_button_down() -> void:
	wave_manager.next_wave()
