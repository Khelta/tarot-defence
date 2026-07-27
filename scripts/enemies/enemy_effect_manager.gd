extends Node
class_name EnemyEffectManager

var effects : Array[EnemyStatusEffect]


func update(delta: float) -> void:
	for effect in effects:
		effect.on_update(delta)

		if effect.is_finished():
			effect.on_remove()
