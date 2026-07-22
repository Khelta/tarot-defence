extends Control
class_name CardSelection

@export var  first_tower : String
@export var second_tower : String
@export var  third_tower : String

var card_scene = preload("res://scenes/ui/card.tscn")

func init(first_tower_string: String, second_tower_string: String, third_tower_string: String) -> void:
	var hbox = get_node("MarginContainer/CenterContainer/VBoxContainer/HBoxContainer")

	first_tower  = first_tower_string
	second_tower = second_tower_string
	third_tower  = third_tower_string

	var first_card = card_scene.instantiate()
	hbox.add_child(first_card)
	first_card.tower_name = first_tower
	first_card.card_selected.connect(selected_card)

	var second_card = card_scene.instantiate()
	hbox.add_child(second_card)
	second_card.tower_name = second_tower
	second_card.card_selected.connect(selected_card)

	var third_card : Card = card_scene.instantiate()
	hbox.add_child(third_card)
	third_card.tower_name = third_tower
	third_card.card_selected.connect(selected_card)


func selected_card(card: Card) -> void:
	queue_free()
