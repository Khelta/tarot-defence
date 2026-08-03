extends Node
class_name BasicEnemyAnimation

@export var animation_player : AnimationPlayer
@export var idle_animation_path : String
@export var running_animation_path : String

func _ready() -> void:
	assert(animation_player != null)
	assert(idle_animation_path != null)
	_idle()


func _idle() -> void:
	AnimationUtils.new(animation_player).set_animation_on_loop(idle_animation_path)
	animation_player.play(idle_animation_path)


func _running() -> void:
	AnimationUtils.new(animation_player).set_animation_on_loop(running_animation_path)
	animation_player.play(running_animation_path)


func _on_state_change(state: BaseEnemy.State) -> void:
	match state:
		BaseEnemy.State.MOVING:
			_running()
