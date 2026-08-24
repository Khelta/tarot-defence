extends Control
class_name CardSelection

@export var  first_tower : TowerData
@export var second_tower : TowerData
@export var  third_tower : TowerData

@export var hbox : HBoxContainer

var card_scene = preload("res://scenes/ui/card.tscn")

func setup(first_tower: TowerData, second_tower: TowerData, third_tower: TowerData) -> void:
	var hbox = get_node("MarginContainer/CenterContainer/VBoxContainer/HBoxContainer")

	first_tower  = first_tower
	second_tower = second_tower
	third_tower  = third_tower

	_add_card(first_tower)
	_add_card(second_tower)
	_add_card(third_tower)


func _add_card(tower: TowerData) -> void:
	var card = card_scene.instantiate()
	hbox.add_child(card)
	card.tower = tower
	card.card_selected.connect(selected_card)


func selected_card(card: Card) -> void:
	queue_free()
