extends CanvasLayer
class_name UI

@export var info_panel : InfoPanel
@export var start_wave_button : StartWaveButton


func _ready() -> void:
	add_to_group("ui")
