extends Button
class_name ExitLevelButton

signal exit_level_pressed


func _pressed() -> void:
	exit_level_pressed.emit()
