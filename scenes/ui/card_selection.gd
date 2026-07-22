extends Control
class_name CardSelection

@export var  first_tower : String
@export var second_tower : String
@export var  third_tower : String

var card_scene = preload("res://scenes/ui/card.tscn")

func init(first_tower: String, second_tower: String, third_tower: String) -> void:
	var hbox = get_node("MarginContainer/CenterContainer/VBoxContainer/HBoxContainer")
	
	var first_card = card_scene.instantiate()
	first_card.tower_name = first_tower
	hbox.add_child(first_card)
	first_card.get_node("Card").button_down.connect(selected_card)
	
	var second_card = card_scene.instantiate()
	second_card.tower_name = second_tower
	hbox.add_child(second_card)
	second_card.get_node("Card").button_down.connect(selected_card)
	
	var third_card : Card = card_scene.instantiate()
	third_card.tower_name = third_tower
	hbox.add_child(third_card)
	third_card.get_node("Card").button_down.connect(selected_card)


func selected_card() -> void:
	queue_free()
