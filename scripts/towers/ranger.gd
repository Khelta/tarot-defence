extends BaseTower
class_name Ranger


func _ready() -> void:
	super()
	
	var ranger_animation : RangerAnimation = get_node("Model")
	self.attack.connect(ranger_animation._on_base_tower_attack)
