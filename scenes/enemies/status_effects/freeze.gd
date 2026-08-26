extends EnemyStatusEffect
class_name Freeze

signal freeze_started
signal freeze_ended


func on_apply() -> void:
	freeze_started.emit()


func on_remove() -> void:
	freeze_ended.emit()
