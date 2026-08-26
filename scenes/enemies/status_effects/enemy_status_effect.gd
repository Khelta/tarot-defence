extends Node
class_name EnemyStatusEffect

var definition : EnemyStatusEffectDefinition

var duration : float
var tick_timer : float = 0.0

var enemy : BaseEnemy


func _init(target: BaseEnemy, effect_definition: EnemyStatusEffectDefinition) -> void:
	enemy = target
	definition = effect_definition

	duration = definition.base_duration


func on_apply() -> void:
	pass


func on_tick() -> void:
	enemy.take_damage(definition.tick_damage)


func on_update(delta: float) -> void:
	duration -= delta

	if definition.ticks:
		tick_timer += delta
		if tick_timer >= definition.tick_rate:
			tick_timer = 0.0
			on_tick()


func is_finished() -> bool:
	return duration <= 0


func refresh() -> void:
	duration = definition.base_duration


func on_remove() -> void:
	queue_free()
