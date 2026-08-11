extends Control
class_name EndScreen

signal continue_button_pressed

func _ready() -> void:
	$VBoxContainer/ContinueButton.pressed.connect(_on_continue_button_pressed)


func _on_continue_button_pressed() -> void:
	continue_button_pressed.emit()


func on_game_won() -> void: 
	visible = true
	$VBoxContainer/Label.text = "Win"


func on_game_lost() -> void:
	visible = true
	$VBoxContainer/Label.text = "Lose"
