class_name TheHangedManAnimation
extends BasicTowerAnimation

func _idle() -> void:
	super._idle()

	var animation = $AnimationPlayer.get_animation(idle_animation_path)
	animation.loop_mode = Animation.LOOP_PINGPONG


func _attack() -> void:
	pass
	await animation_player.animation_finished
	_idle()
