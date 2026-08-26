extends Resource
class_name EnemyStatusEffect

var definition : EnemyStatusEffectDefinition

var duration : float
var tick_timer : float = 0.0

var enemy : BaseEnemy

var base_duration = definition.base_duration
var tick_damage = definition.tick_damage
var ticks = definition.ticks
var tick_rate = definition.tick_rate


func _init(target: BaseEnemy) -> void:
	enemy = target
	duration = base_duration


func on_apply() -> void:
	pass


func on_tick() -> void:
	enemy.take_damage(tick_damage)


func on_update(delta: float) -> void:
	duration -= delta

	if ticks:
		tick_timer += delta
		if tick_timer >= tick_rate:
			tick_timer = 0.0
			on_tick()


func is_finished() -> bool:
	return duration <= 0


func refresh() -> void:
	duration = base_duration
