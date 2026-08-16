extends Node
class_name Root

@export var main_menu_scene : PackedScene
@export var level_scene : PackedScene

var current_level_index : int


func _ready() -> void:
	load_main_menu()


func load_main_menu() -> void: 
	delete_current_scene()

	var main_menu = main_menu_scene.instantiate() as MainMenu
	add_child(main_menu)
	
	main_menu.main_menu_start_button.start_level_pressed.connect(load_level)


func load_level(level_number: int = current_level_index) -> void:
	delete_current_scene()

	current_level_index = level_number

	var level = level_scene.instantiate() as Level
	add_child(level)

	var exit_level_button = level.ui.end_screen.exit_level_button
	exit_level_button.exit_level_pressed.connect(load_main_menu)
	
	var retry_button = level.ui.end_screen.retry_button
	retry_button.replay_button_pressed.connect(load_level)


func delete_current_scene() -> void:
	for child in get_children():
		child.queue_free()
