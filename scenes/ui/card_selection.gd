extends Control
class_name CardSelection

@export var  first_tower : String
@export var second_tower : String
@export var  third_tower : String

@export var hbox : HBoxContainer

var card_scene = preload("res://scenes/ui/card.tscn")

func setup(first_tower_string: String, second_tower_string: String, third_tower_string: String) -> void:
	var hbox = get_node("MarginContainer/CenterContainer/VBoxContainer/HBoxContainer")

	first_tower  = first_tower_string
	second_tower = second_tower_string
	third_tower  = third_tower_string

	_add_card(first_tower)
	_add_card(second_tower)
	_add_card(third_tower)


func _add_card(tower_string: String) -> void:
	var card = card_scene.instantiate()
	hbox.add_child(card)
	card.tower_name = tower_string
	card.card_selected.connect(selected_card)


func selected_card(card: Card) -> void:
	queue_free()
