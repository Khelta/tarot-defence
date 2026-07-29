extends EnemyStatusEffect
class_name Freeze

signal freeze_started
signal freeze_ended

func _init(target: BaseEnemy, _base_duration: float = 3.0) -> void:
	id = "freeze"
	stack_type = StackType.IGNORE
	
	base_duration = _base_duration

	super._init(target)


func on_apply() -> void:
	freeze_started.emit()


func on_remove() -> void:
	freeze_ended.emit()
