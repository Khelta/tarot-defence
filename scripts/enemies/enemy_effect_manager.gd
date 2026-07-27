extends Node
class_name EnemyEffectManager

var effects : Array[EnemyStatusEffect]

func add_effect(effect: EnemyStatusEffect) -> void:
	var existing = get_effects_by_id(effect.id)

	match effect.stack_type:

		EnemyStatusEffect.StackType.STACK_REFRESH:
			for old_effect in existing:
				old_effect.refresh()
			effect.on_apply()
			effects.append(effect)

		EnemyStatusEffect.StackType.STACK_NO_REFRESH:
			effect.on_apply()
			effects.append(effect)

		EnemyStatusEffect.StackType.REFRESH:
			if len(existing) > 0:
				existing[0].refresh()
			else:
				effect.on_apply()
				effects.append(effect)

		EnemyStatusEffect.StackType.REPLACE:
			if len(existing) > 0:
				existing[0].on_remove()
			effect.on_apply()
			effects.append(effect)

		EnemyStatusEffect.StackType.IGNORE:
			if len(existing) == 0:
				effect.on_apply()
				effects.append(effect)


func _process(delta: float) -> void:
	for effect in effects:
		effect.on_update(delta)

		if effect.is_finished():
			effects.erase(effect)
			effect.on_remove()


func get_effects_by_id(status_id: String) -> Array[EnemyStatusEffect]:
	return effects.filter(func(effect): return effect.id == status_id)
