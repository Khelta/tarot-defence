extends Node
class_name TowerEffectManager

var effects : Array[TowerStatusEffect]
var tower : BaseTower


func _ready() -> void:
	tower = get_parent().get_parent()


func add_effect(effect: TowerStatusEffect) -> void:
	connect_signals(effect)

	var existing = get_effects_by_id(effect.id)

	match effect.stack_type:

		TowerStatusEffect.StackType.STACK_REFRESH:
			for old_effect in existing:
				old_effect.refresh()
			effect.on_apply()
			effects.append(effect)

		TowerStatusEffect.StackType.STACK_NO_REFRESH:
			effect.on_apply()
			effects.append(effect)

		TowerStatusEffect.StackType.REFRESH:
			if len(existing) > 0:
				existing[0].refresh()
			else:
				effect.on_apply()
				effects.append(effect)

		TowerStatusEffect.StackType.REPLACE:
			if len(existing) > 0:
				existing[0].on_remove()
			effect.on_apply()
			effects.append(effect)

		TowerStatusEffect.StackType.IGNORE:
			if len(existing) == 0:
				effect.on_apply()
				effects.append(effect)


func connect_signals(effect: TowerStatusEffect):
	pass


func _process(delta: float) -> void:
	for effect in effects:
		effect.on_update(delta)

		if effect.is_finished():
			effects.erase(effect)
			effect.on_remove()


func get_effects_by_id(status_id: String) -> Array[EnemyStatusEffect]:
	return effects.filter(func(effect): return effect.id == status_id)
