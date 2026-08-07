@tool
extends BaseTower
class_name Knight


func _ready() -> void:
	super()
	
	var knight_animation : KnightAnimation = get_node("Model")
	self.attacked.connect(knight_animation._on_base_tower_attack)
	self.grabbed.connect(knight_animation._on_grab)
	self.grab_released.connect(knight_animation._on_grab_released)


func _process(delta) -> void:
	attack_cooldown -= delta
	if attack_cooldown <= 0.0 and len(enemies_in_range) != 0 and not is_grabbed:

		for target_enemy in enemies_in_range:
			apply_damage(target_enemy)

		attacked.emit()
		attack_cooldown = 1.0 / (attacks_per_second * tower_effect_manager.get_attack_speed_modifier())
