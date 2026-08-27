extends Resource
class_name EnemyStatusEffectDefinition

enum StackType{
	STACK_REFRESH,    # Multiple copies refresh on appliance
	STACK_NO_REFRESH, # Multiple copies no refresh on appliance
	REFRESH,          # Refresh without stacking
	REPLACE,          # Replace old effect
	IGNORE,           # Do nothing if already active
}

@export var id : String

@export var base_duration : float

@export var stack_type : StackType = StackType.IGNORE

@export var ticks : bool = true
@export var tick_rate : float = 1.0
@export var tick_damage : float = 0.0

@export var particle_effect : PackedScene
