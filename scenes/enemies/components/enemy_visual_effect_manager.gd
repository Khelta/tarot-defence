extends Node
class_name EnemyVisualEffectManager

var effects : Array[EnemyStatusEffect]
var particle_effects : Array


func add_effect(effect: EnemyStatusEffect) -> void:
	if not effect.definition.particle_effect:
		return 

	for existing in effects:
		if existing.get_script() == effect.get_script():
			return

	effects.append(effect)

	var particle_effect = effect.definition.particle_effect.instantiate()
	add_child(particle_effect)

	particle_effects.append(particle_effect)


func remove_effect(effect: EnemyStatusEffect) -> void:
	for existing in effects:
		if existing.get_script() == effect.get_script():

			var index = effects.find(existing)

			var particle_effect = particle_effects[index]
			particle_effects.erase(particle_effect)

			particle_effect.queue_free()

			effects.erase(effect)
