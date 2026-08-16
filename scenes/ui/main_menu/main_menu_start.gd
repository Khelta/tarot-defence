extends Button
class_name MainMenuStart

signal start_level_pressed(level_number: int)

func _on_button_down() -> void:
	start_level_pressed.emit(1)
