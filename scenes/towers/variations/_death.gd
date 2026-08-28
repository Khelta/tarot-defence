@tool
extends BaseTower
class_name Death


func _ready() -> void:
	super()
	
	var death_animation : DeathAnimation = get_node("Model")
	self.attacked.connect(death_animation._on_base_tower_attack)
	self.grabbed.connect(death_animation._on_grab)
	self.grab_released.connect(death_animation._on_grab_released)
