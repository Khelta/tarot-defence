extends Node
class_name EnemyEffectManager

var effects : Array[EnemyStatusEffect]
var enemy : BaseEnemy


func _ready() -> void:
	enemy = get_parent().get_parent()


func add_effect(effect: EnemyStatusEffect) -> void:
	connect_signals(effect)

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


func connect_signals(effect: EnemyStatusEffect) -> void:
	if effect is Freeze:
		effect.freeze_started.connect(enemy.on_freeze_started)
		effect.freeze_ended.connect(enemy.on_freeze_ended)


func _process(delta: float) -> void:
	for effect in effects:
		effect.on_update(delta)

		if effect.is_finished():
			effects.erase(effect)
			effect.on_remove()


func get_effects_by_id(status_id: String) -> Array[EnemyStatusEffect]:
	return effects.filter(func(effect): return effect.id == status_id)


func get_speed_modifier() -> float:
	var slows = get_effects_by_id("slow")
	var speed_modifier = 1.0
	
	for slow in slows:
		speed_modifier *= slow.factor
	
	speed_modifier = min(speed_modifier, 0.3)
	return speed_modifier


func is_frozen():
	return len(effects.filter(func(effect): return effect.id == "freeze")) > 0
