extends Node
class_name EnemyStatusEffect

var enemy: BaseEnemy

var base_duration: float
var duration: float

var ticks : bool = true
var tick_timer : float = 0.0
var tick_rate : float = 1.0

func _init(target: BaseEnemy) -> void:
	enemy = target
	duration = base_duration


func on_apply() -> void:
	pass


func on_tick() -> void:
	pass


func on_update(delta: float) -> void:
	duration -= delta

	if ticks:
		if tick_timer >= tick_rate:
			tick_timer = 0.0
			on_tick()


func on_remove() -> void:
	queue_free()


func is_finished() -> bool:
	return duration <= 0


func refresh() -> void:
	pass
