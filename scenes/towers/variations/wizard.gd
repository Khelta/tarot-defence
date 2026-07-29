@tool
extends BaseTower
class_name Wizard


func _ready() -> void:
	super()
	
	var wizard_animation : WizardAnimation = get_node("Model")
	self.attacked.connect(wizard_animation._on_base_tower_attack)
	self.grabbed.connect(wizard_animation._on_grab)
	self.grab_released.connect(wizard_animation._on_grab_released)
