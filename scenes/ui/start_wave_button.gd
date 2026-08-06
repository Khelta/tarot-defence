extends Button
class_name StartWaveButton

var wave_manager: WaveManager = null

signal start_wave_button_pressed


func _on_wave_started(_wave_index: int, _waves_length: int) -> void:
	visible = false


func _on_wave_ended(wave_index: int, waves_length: int) -> void:
	if wave_index <= waves_length - 1:
		visible = true


func _on_button_down() -> void:
	start_wave_button_pressed.emit()
