extends EnemyStatusEffect
class_name Burn

var tick_damage : float = 10.0

func _init(target: BaseEnemy) -> void:
	id = "burn"

	base_duration = 3.0
	ticks = true
	tick_rate = 1.0

	super._init(target)


func on_tick() -> void:
	enemy.take_damage(tick_damage)
	

func refresh() -> void:
	duration = base_duration
