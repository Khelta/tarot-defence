class_name SkeletonNecromancerAnimation
extends BasicEnemyAnimation

func _ready() -> void:
	super._ready()
	var utils = AnimationUtils.new(animation_player)
	utils.set_animation_on_loop("Rig_Medium_CombatRanged/Ranged_Magic_Spellcasting")

func _casting() -> void:
	animation_player.play("Rig_Medium_CombatRanged/Ranged_Magic_Spellcasting")


func _on_cast_finished() -> void:
	animation_player.play("Rig_Medium_CombatRanged/Ranged_Magic_Raise")
