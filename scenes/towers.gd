extends Node
class_name Towers

const RangerClass = preload("res://scenes/models/towers/ranger.tscn")
const KnightClass = preload("res://scenes/models/towers/knight.tscn")

var tower_class_dict : Dictionary[String, PackedScene] = {
	"Ranger": RangerClass,
	"Knight": KnightClass
}

var bench : Bench = null

func _ready() -> void: 
	bench = get_node("Bench")
	add_tower("Ranger")
	add_tower("Ranger2")
	add_tower("Knight")


func check_upgrade() -> void:
	var counter: = { "Ranger1": [],
					 "Ranger2": [],
					 "Knight1": [],
					 "Knight2": []}

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


func add_tower(tower_name: String) -> bool:
	if not bench.has_free_slot():
		return false

	var star_level = TowerUtils.get_star_level_from_tower_string(tower_name)
	tower_name = TowerUtils.remove_star_level_from_tower_string(tower_name)
	
	var tower_class = tower_class_dict[tower_name]
	var tower : BaseTower = tower_class.instantiate()
	
	for i in range(1, star_level):
		tower.upgrade()
	
	add_child(tower)
	var bench_slot = bench.give_next_free_slot()
	bench_slot.tower = tower
	
	return true


func _on_child_entered_tree(_node: Node) -> void:
	check_upgrade()
