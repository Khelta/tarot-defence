extends AspectRatioContainer
class_name Card

var game_state : GameState
@export var tower_name : String
@onready var button : TextureButton

signal card_selected(card: Card)

func _ready() -> void:
	button = get_node("Card")
	
	await get_tree().process_frame
	game_state = get_tree().get_first_node_in_group("game_state")


func _on_card_button_down() -> void:
	var towers : Towers = game_state.get_node("Towers")
	towers.add_tower(tower_name)
	card_selected.emit(self)
