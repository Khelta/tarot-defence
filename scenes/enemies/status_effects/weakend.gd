extends EnemyStatusEffect
class_name Weakend

var factor : float = 1.0

func _init(target: BaseEnemy, weakend_factor: float = 1.25, _base_duration: float = 3.0) -> void:
	id = "weakend"
	stack_type = StackType.REFRESH
	
	factor = weakend_factor
	base_duration = _base_duration

	super._init(target)


func refresh() -> void:
	duration = base_duration
