extends Control
class_name EndScreen

signal continue_button_pressed


@export var continue_button : Button
@export var retry_button : Button

func _ready() -> void:
	$VBoxContainer/ContinueButton.pressed.connect(_on_continue_button_pressed)


func _on_continue_button_pressed() -> void:
	continue_button_pressed.emit()


func on_game_won() -> void: 
	visible = true
	
	continue_button.visible = true
	$VBoxContainer/Label.text = "Win"


func on_game_lost() -> void:
	visible = true
	
	retry_button.visible = true
	$VBoxContainer/Label.text = "Lose"
