class_name RangerAnimation
extends BasicTowerAnimation


func _attack() -> void:
	animation_player.play("Rig_Medium_CombatRanged/Ranged_Bow_Draw")
	animation_player.play("Rig_Medium_CombatRanged/Ranged_Bow_Release")
	await animation_player.animation_finished
	_idle()
