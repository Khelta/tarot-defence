extends Node3D
class_name BaseEnemy

@export var max_hp: float = 100.0
@export var base_speed: float = 1.0
@export var damage: float = 1.0
@export var gold_on_death: int = 1

var current_hp: float = max_hp
var is_alive: bool = true

var enemy_effect_manager : EnemyEffectManager
var animation_player : AnimationPlayer
var health_bar : HealthBar

signal hp_changed(current_hp: float, max_hp: float)
signal enemy_died(gold_on_death: int)


func _ready() -> void:
	enemy_effect_manager = get_node("BaseEnemy/EnemyEffectManager")
	animation_player = get_node("Model").get_node("AnimationPlayer") as AnimationPlayer
	
	health_bar = get_node("HealthBarViewPort/HealthBar")
	hp_changed.connect(health_bar._update_hp)
	hp_changed.emit(current_hp, max_hp)


func take_damage(amount: float) -> Array:
	current_hp -= amount
	hp_changed.emit(current_hp, max_hp)
	var died = false
	if current_hp <= 0:
		died = on_death()
	return [amount, died]

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
	
