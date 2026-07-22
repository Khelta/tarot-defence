extends Node
class_name GameState

@export var path : Path3D

@export var max_player_health : float = 100.0
var current_player_health: float

@export var current_player_gold : int = 10

signal player_health_changed(c_player_health: float)
signal player_gold_changed(c_player_gold: int)

func _change_player_health(value: float):
	current_player_health = clamp(current_player_health + value , 0.0, max_player_health)
	player_health_changed.emit(current_player_health)


func _change_player_gold(value: int):
	current_player_gold = max(0, current_player_gold + value)
	player_gold_changed.emit(current_player_gold)


func _ready() -> void:
	add_to_group("game_state")
	
	current_player_health = max_player_health
	
	var lifebar = get_node("../Ui/InfoPanel/VBoxContainer/LifeBar")
	player_health_changed.connect(lifebar._on_lifepoints_changed)
	_change_player_health(current_player_health)
	
	var goldlabel = get_node("../Ui/InfoPanel/VBoxContainer/GoldLabel")
	player_gold_changed.connect(goldlabel._on_gold_changed)
	_change_player_gold(0)


func buy_booster(price: int) -> void:
	if price > current_player_gold:
		return
	else:
		_change_player_gold(-price)
		
		await get_tree().process_frame

		var ui = get_tree().get_first_node_in_group("ui")
		var card_selection_scene = preload("res://scenes/ui/card_selection.tscn")
		var card_selection = card_selection_scene.instantiate()
		card_selection.init("Ranger", "Ranger", "Ranger")

		ui.add_child(card_selection)


func _process(delta):
	var path_length: float = get_node("Path").curve.get_baked_length()
	var enemy_speed = 20
	var time_for_path = path_length * enemy_speed
	var progress_ratio_speed = 100 / time_for_path


	for enemy_path in path.get_children():
		var enemy = enemy_path.get_child(0).get_node("BaseEnemy")
		if enemy.is_alive:
			var previous_progress_ratio = enemy_path.progress_ratio
			enemy_path.progress_ratio += progress_ratio_speed * delta

			if enemy_path.progress_ratio < previous_progress_ratio:
				_change_player_health(-enemy.damage)
