extends Node3D
class_name BaseEnemy

@export var max_hp: float = 100.0
@export var base_speed: float = 1.0
@export var damage: float = 1.0
@export var gold_on_death: int = 1

enum State {
	MOVING,
	CASTING,
}

var state = State.MOVING:
	set(value):
		state = value
		state_changed.emit(value)

var current_hp: float
var is_alive: bool = true

var enemy_effect_manager : EnemyEffectManager
var health_bar : HealthBar

var animation_player : AnimationPlayer
var animation_class : BasicEnemyAnimation

var is_caster : bool
var cast_cooldown : float
var cast_duration : float

signal state_changed(state: State)

signal enemy_spawned(enemy: BaseEnemy)

signal begined_casting()
signal casting_finished()

signal hp_changed(current_hp: float, max_hp: float)
signal enemy_died(gold_on_death: int)


func _ready() -> void:
	enemy_effect_manager = get_node("BaseEnemy/EnemyEffectManager")
	animation_player = get_node("Model").get_node("AnimationPlayer") as AnimationPlayer
	
	health_bar = get_node("HealthBarViewPort/HealthBar")
	current_hp = max_hp
	hp_changed.connect(health_bar._update_hp)
	hp_changed.emit(current_hp, max_hp)
	
	state_changed.connect(animation_class._on_state_change)
	
	if is_caster:
		casting_loop()



func take_damage(amount: float) -> Array:
	var weakend_modifier = enemy_effect_manager.get_weakend_modifier()
	var hp_damage = amount * weakend_modifier
	
	current_hp -= hp_damage
	hp_changed.emit(current_hp, max_hp)
	var died = false
	if current_hp <= 0:
		died = on_death()
	return [hp_damage, died]

func death_animation(_no_value: int) -> void:
	pass

func on_death() -> bool:
	if not is_alive:
		return false
	is_alive = false

	var area_node = get_node("BaseEnemy/Area3D")
	area_node.monitorable = false
	var overlapping_areas = $BaseEnemy/Area3D.get_overlapping_areas()

	for area in overlapping_areas:
		var area_parent = area.get_parent()
		if area_parent.is_in_group("base_tower"):
			var base_tower_area = area_parent.get_node("BaseEnemy/Area3D")
			base_tower_area._on_area_3d_area_exited(area_node)

	area_node.queue_free()
	enemy_died.connect(death_animation)
	enemy_died.emit(gold_on_death)
	
	return true


func is_frozen() -> bool:
	return enemy_effect_manager.is_frozen()


func on_freeze_started() -> void:
	animation_player.pause()


func on_freeze_ended() -> void:
	animation_player.play()


func get_speed() -> float:
	if is_frozen():
		return 0
	else:
		return base_speed * enemy_effect_manager.get_speed_modifier()


func casting_loop():
	while is_alive:
		await get_tree().create_timer(cast_cooldown).timeout
		if is_alive:
			await start_cast()


func start_cast():
	if state == State.CASTING:
		return

	if is_alive:
		state = State.CASTING
		begined_casting.emit()
		await get_tree().create_timer(cast_duration).timeout

	if is_alive:
		casting_finished.emit()
		cast_spell()
		await animation_player.animation_finished

		state = State.MOVING


func cast_spell() -> void:
	assert(false, "Implement on_cast_finished")
