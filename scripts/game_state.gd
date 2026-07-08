extends Node

@export var path : Path3D

@export var max_player_health : float = 100.0
var current_player_health: float

signal player_health_changed(c_player_health: float)

func _change_player_health(value: float):
	current_player_health = clamp(current_player_health + value , 0.0, max_player_health)
	player_health_changed.emit(current_player_health)


func _ready() -> void:
	add_to_group("game_state")
	current_player_health = max_player_health
	
	var lifebar = get_parent().get_node("Ui/InfoPanel/LifeBar")
	player_health_changed.connect(lifebar._on_lifepoints_changed)
	_change_player_health(current_player_health)
	


func _process(delta):
	var path_length: float = get_child(0).curve.get_baked_length()
	var enemy_speed = 20
	var time_for_path = path_length * enemy_speed
	var progress_ratio_speed = 100 / time_for_path
	
	
	
	for enemy_path in path.get_children():
		if enemy_path.get_child(0).get_child(0).is_alive():
			var previous_progress_ratio = enemy_path.progress_ratio
			enemy_path.progress_ratio += progress_ratio_speed * delta
			
			if enemy_path.progress_ratio < previous_progress_ratio:
				var enemy = enemy_path.get_child(0).get_node("BaseEnemy")
				_change_player_health(-enemy.damage)
