extends Node3D

@export var animation_player : AnimationPlayer


func _ready() -> void:
	set_animation_on_loop("Rig_Medium_CombatRanged/Ranged_Bow_Idle")
	_idle()


func _idle() -> void:
	animation_player.play("Rig_Medium_CombatRanged/Ranged_Bow_Idle")


func _attack() -> void:
	animation_player.play("Rig_Medium_CombatRanged/Ranged_Bow_Draw")
	animation_player.play("Rig_Medium_CombatRanged/Ranged_Bow_Release")
	await animation_player.animation_finished
	_idle()


func set_animation_on_loop(animation_name: String) -> void: 
	var anim : Animation = animation_player.get_animation(animation_name)
	anim.loop_mode = (Animation.LOOP_LINEAR)


func _on_base_tower_attack() -> void:
	_attack()
