extends Node

var enemies: Array[EnemyData] = [
	preload("res://scenes/enemies/resources/skeleton_minion.tres"),
	preload("res://scenes/enemies/resources/skeleton_necromancer.tres"),
]

var enemy_data_dict : Dictionary = {}
var enemy_scenes_dict : Dictionary = {}


func _ready() -> void:
	for enemy in enemies:
		enemy_data_dict[enemy.abbreviation] = enemy
		enemy_scenes_dict[enemy.abbreviation] = enemy.enemy_scene
