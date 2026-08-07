extends BasicTowerAnimation
class_name KnightAnimation


func _attack() -> void:
	animation_player.play("Rig_Medium_CombatMelee/Melee_2H_Attack_Spin")
	await animation_player.animation_finished
	_idle()
