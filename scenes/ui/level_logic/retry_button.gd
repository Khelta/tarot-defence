extends Button

signal replay_button_pressed

func _pressed() -> void:
	replay_button_pressed.emit()
