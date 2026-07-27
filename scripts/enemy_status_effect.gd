extends Node
class_name EnemyStatusEffect

var base_duration: float
var duration: float = base_duration

var ticks : bool = true
var tick_timer : float = 0.0
var tick_rate : float = 1.0

func on_apply(enemy: BaseEnemy) -> void:
	pass


func  on_tick(enemy: BaseEnemy) -> void:
	pass


func on_update(enemy: BaseEnemy, delta: float) -> void:
	duration -= delta

	if ticks:
		if tick_timer >= tick_rate:
			tick_timer = 0.0
			on_tick(enemy)


func on_remove(enemy) -> void:
	queue_free()


func is_finished() -> bool:
	return duration <= 0
