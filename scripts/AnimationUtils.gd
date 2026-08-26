extends Node
class_name AnimationUtils

var animation_player : AnimationPlayer

func _init(anim_player: AnimationPlayer) -> void:
	animation_player = anim_player

func set_animation_on_loop(
	animation_name: String,
	loop_mode: Animation.LoopMode = Animation.LOOP_LINEAR
	) -> void: 
	var anim : Animation = animation_player.get_animation(animation_name)
	anim.loop_mode = loop_mode
