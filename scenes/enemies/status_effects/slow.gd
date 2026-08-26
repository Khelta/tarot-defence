extends EnemyStatusEffect
class_name Slow

var factor : float = 1.0

func _init(target: BaseEnemy, effect_definition: EnemyStatusEffectDefinition, slow_factor: float = 0.5) -> void:
	factor = slow_factor

	super._init(target, effect_definition)
