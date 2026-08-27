extends Node
class_name Towers


@export var level : Level
var bench : Bench

func _ready() -> void: 
	bench = level.bench


func check_upgrade() -> void:
	const TOWER_DATABASE : TowerPool = preload("uid://k5ny03sks1x7")
	
	var counter = {}
	for tower in TOWER_DATABASE.towers:
		counter[tower.name + "1"] = []
		counter[tower.name + "2"] = []

	var upgraded : bool = false

	for tower in get_children():
		if tower is Bench:
			continue
		var tower_class = tower.get_script().get_global_name() + str(tower.star_level)
		if tower_class in counter:
			counter[tower_class].append(tower)
			if len(counter[tower_class]) == 3:
				upgraded = true
				counter[tower_class][0].upgrade()
				counter[tower_class][1].queue_free()
				counter[tower_class][2].queue_free()
				
	if upgraded:
		check_upgrade()


func add_tower(tower_data: TowerData, star_level: int = 1) -> bool:
	if not bench.has_free_slot():
		return false
	
	var tower_scene = tower_data.tower_scene
	var tower : BaseTower = tower_scene.instantiate()
	
	for i in range(1, star_level):
		tower.upgrade()
	
	add_child(tower)
	var bench_slot = bench.give_next_free_slot()
	bench_slot.tower = tower
	
	return true


func _on_child_entered_tree(_node: Node) -> void:
	check_upgrade()
