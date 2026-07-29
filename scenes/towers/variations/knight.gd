@tool
extends BaseTower
class_name Knight


func _ready() -> void:
	super()
	
	var knight_animation : KnightAnimation = get_node("Model")
	self.attacked.connect(knight_animation._on_base_tower_attack)
	self.grabbed.connect(knight_animation._on_grab)
	self.grab_released.connect(knight_animation._on_grab_released)
