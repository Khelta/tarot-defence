extends AspectRatioContainer
class_name Card

var game_state : GameState
@export var tower_name : String
@onready var button : TextureButton

signal card_selected(card: Card)

var ranger_image = preload("res://assets/preview_images/Ranger.png")
var knight_image = preload("res://assets/preview_images/Knight.png")
var wizard_image = preload("res://assets/preview_images/Wizard.png")

var tower_to_texture_dict = {
	"Ranger": ranger_image,
	"Knight": knight_image,
	"Wizard": wizard_image,
	}

func _ready() -> void:
	button = get_node("Card")

	await get_tree().process_frame
	game_state = get_tree().get_first_node_in_group("game_state")

	button.texture_normal = tower_to_texture_dict[
		TowerUtils.remove_star_level_from_tower_string(tower_name)
		]


func _on_card_button_down() -> void:
	var towers : Towers = game_state.get_node("Towers")
	towers.add_tower(tower_name)
	card_selected.emit(self)
