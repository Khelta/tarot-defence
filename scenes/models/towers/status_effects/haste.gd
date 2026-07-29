extends TowerStatusEffect
class_name Haste

var factor : float = 1.0

func _init(target: BaseTower, _factor: float = 1.0, _base_duration: float = 3.0) -> void:
	id = "haste"
	stack_type = StackType.REFRESH
	
	base_duration = _base_duration
	factor = _factor

	super._init(target)


func refresh() -> void:
	duration = base_duration
