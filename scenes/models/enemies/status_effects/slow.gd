extends EnemyStatusEffect
class_name Slow

var factor : float = 1.0

func _init(target: BaseEnemy, slow_factor: float = 0.5, _base_duration: float = 3.0) -> void:
	id = "slow"
	stack_type = StackType.REFRESH
	
	factor = slow_factor
	base_duration = _base_duration

	super._init(target)


func refresh() -> void:
	duration = base_duration
