extends EnemyStatusEffect
class_name Weakend

var factor : float = 1.0

func _init(target: BaseEnemy, effect_definition: EnemyStatusEffectDefinition, weakend_factor: float = 1.25) -> void:
	factor = weakend_factor

	super._init(target, effect_definition)
