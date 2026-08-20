class_name TheHangedManAnimation
extends BasicTowerAnimation

func _idle() -> void:
	AnimationUtils.new(animation_player).set_animation_on_loop(
		idle_animation_path,
		Animation.LOOP_PINGPONG
	)

	animation_player.play(idle_animation_path)


func _attack() -> void:
	pass
	await animation_player.animation_finished
	_idle()
