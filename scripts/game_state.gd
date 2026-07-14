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
	
	#TODO delete
	var ranger_scene = preload("res://scenes/models/towers/ranger.tscn")
	var towers = get_node("Towers")
	var ranger = ranger_scene.instantiate()
	towers.add_child(ranger)
	get_node("Bench/BenchSlot2").tower = ranger
	
	ranger = ranger_scene.instantiate()
	towers.add_child(ranger)
	get_node("Bench/BenchSlot").tower = ranger
	
	ranger = ranger_scene.instantiate()
	towers.add_child(ranger)
	get_node("Bench/BenchSlot4").tower = ranger
	
	var knight_scene = preload("res://scenes/models/towers/knight.tscn")
	var knight = knight_scene.instantiate()
	towers.add_child(knight)
	get_node("Bench/BenchSlot3").tower = knight


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
