extends Node
class_name BasicEnemyAnimation

@export var animation_player : AnimationPlayer
@export var idle_animation_path : String

func _ready() -> void:
	assert(animation_player != null)
	assert(idle_animation_path != null)
	_idle()


func _idle() -> void:
	AnimationUtils.new(animation_player).set_animation_on_loop(idle_animation_path)
	animation_player.play(idle_animation_path)
