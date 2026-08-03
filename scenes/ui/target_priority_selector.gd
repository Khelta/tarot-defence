extends MenuButton

@export var tower_panel: TowerPanel

var popup : PopupMenu

func _ready():
	popup = get_popup()

	for priority in BaseTower.TargetPriority.values():
		popup.add_item(BaseTower.TargetPriority.keys()[priority], priority)

	popup.id_pressed.connect(_on_menu_item_pressed)


func _on_menu_item_pressed(id: int):
	tower_panel.current_tower.set_target_priority(id as BaseTower.TargetPriority)
