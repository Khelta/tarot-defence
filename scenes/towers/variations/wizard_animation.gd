class_name WizardAnimation
extends BasicTowerAnimation


func _attack() -> void:
	animation_player.play("Rig_Medium_CombatRanged/Ranged_Magic_Spellcasting_Long")
	animation_player.play("Rig_Medium_CombatRanged/Ranged_Magic_Shoot")
	await animation_player.animation_finished
	_idle()
