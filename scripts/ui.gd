extends CanvasLayer
class_name UI

@export var info_panel : InfoPanel
@export var start_wave_button : StartWaveButton
@export var end_screen : EndScreen
@export var sell_tower_button : SellTowerButton
@export var tower_panel : TowerPanel

func _ready() -> void:
	add_to_group("ui")
