extends AspectRatioContainer
class_name Card

var level : Level
@export var tower : TowerData
@onready var button : TextureButton

signal card_selected(card: Card)

func _ready() -> void:
	assert(tower != null)
	
	button = get_node("Card")

	await get_tree().process_frame
	level = get_tree().get_first_node_in_group("level")

	button.texture_normal = tower.image


func _on_card_button_down() -> void:
	var towers : Towers = level.towers
	# TODO change function to take TowerData as parameter
	towers.add_tower(tower.name)
	card_selected.emit(self)
