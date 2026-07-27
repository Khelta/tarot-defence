extends Node
class_name EnemyEffectManager

var effects : Array[EnemyStatusEffect]


func update(delta: float) -> void:
	for effect in effects:
		effect.on_update(get_parent(), delta)

		if effect.is_finished():
			effect.on_remove(get_parent())
