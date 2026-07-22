extends Button

@onready var root = get_tree().get_first_node_in_group("root")
@onready var main_menu = get_tree().get_first_node_in_group("main_menu")

func _on_button_down() -> void:
	var level_scene = load("res://scenes/levels/level_1.tscn")
	var level_instance = level_scene.instantiate()
	root.add_child(level_instance)
	main_menu.queue_free()
