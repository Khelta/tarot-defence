@tool
extends BaseTower
class_name Ranger


func _ready() -> void:
	super()
	
	var ranger_animation : RangerAnimation = get_node("Model")
	self.attacked.connect(ranger_animation._on_base_tower_attack)
	self.grabbed.connect(ranger_animation._on_grab)
	self.grab_released.connect(ranger_animation._on_grab_released)
