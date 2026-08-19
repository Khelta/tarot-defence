extends Button
class_name BuyBoosterButton

var game_state : GameState

func _ready() -> void:
	await get_tree().process_frame
	game_state = get_tree().get_first_node_in_group("game_state")

func _on_button_down() -> void:
	game_state.buy_booster(5)
