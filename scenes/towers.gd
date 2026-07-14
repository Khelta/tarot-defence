extends Node


func check_upgrade() -> void:
	print("Checked!")
	var counter: = { "Ranger1": [],
					 "Ranger2": [],
					 "Knight1": [],
					 "Knight2": []}


	for tower in get_children():
		var tower_class = tower.get_script().get_global_name() + str(tower.star_level)
		if tower_class in counter:
			counter[tower_class].append(tower)
			if len(counter[tower_class]) == 3:
				counter[tower_class][0].upgrade()
				counter[tower_class][1].queue_free()
				counter[tower_class][2].queue_free()


func _on_child_entered_tree(node: Node) -> void:
	check_upgrade()
