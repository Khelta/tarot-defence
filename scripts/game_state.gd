extends Node
class_name GameState

@export var path : Path3D
const path_speed = 10

@export var max_player_health : float = 100.0
var current_player_health: float

@export var current_player_gold : int = 10

@export var tower_pool : TowerPool

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
		
		card_selection.setup(tower_pool.draw_weighted().name,
							 tower_pool.draw_weighted().name,
							 tower_pool.draw_weighted().name)

		ui.add_child(card_selection)


func _process(delta):
	for enemy_path in path.get_children():
		var enemy = enemy_path.get_child(0)

		if enemy.is_alive:
			if enemy.state == enemy.State.CASTING:
				continue

			var previous_progress_ratio = enemy_path.progress_ratio
			var progress_ratio_speed = calculate_progress_ratio_speed(enemy)

			enemy_path.progress_ratio += progress_ratio_speed * delta

			if enemy_path.progress_ratio < previous_progress_ratio:
				_change_player_health(-enemy.damage)


func calculate_progress_ratio_speed(enemy: BaseEnemy) -> float:
	var path_length: float = path.curve.get_baked_length()
	var time_for_path = path_length * path_speed
	var progress_ratio_speed = 100 / time_for_path * enemy.get_speed()
	return progress_ratio_speed
	
