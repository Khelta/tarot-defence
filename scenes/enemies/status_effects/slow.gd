extends EnemyStatusEffect
class_name Slow

var factor : float = 1.0

func _init(target: BaseEnemy, slow_factor: float = 0.5, _base_duration: float = 3.0) -> void:
	factor = slow_factor

	super._init(target)
