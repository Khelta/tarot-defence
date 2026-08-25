@tool
extends BaseTower
class_name TheHangedMan


func _ready() -> void:
	super()


func _process(delta) -> void:
	attack_cooldown -= delta
	if attack_cooldown <= 0.0 and len(enemies_in_range) != 0 and not is_grabbed:

		for enemy in enemies_in_range:
			apply_damage(enemy)

		attacked.emit()
		attack_cooldown = 1.0 / (attacks_per_second * tower_effect_manager.get_attack_speed_modifier())


"""
	var hanged_man_animation : TheHangedManAnimation = get_node("Model")
	self.attacked.connect(hanged_man_animation._on_base_tower_attack)
"""
