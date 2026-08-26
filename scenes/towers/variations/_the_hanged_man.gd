extends BaseTower
class_name TheHangedMan

@export var max_range : float = -1
@export var min_range : float = -1
@export var halo_expansion_time : float = -1
@export var halo_curve : Curve

var halo_expansion_direction : int = 1
var halo_time : float = 0.0

var holy_burn : Resource = preload("res://scenes/enemies/status_effects/holy_burn.tres")

func _ready() -> void:
	assert(max_range != -1)
	assert(min_range != -1)
	assert(halo_expansion_time != -1)

	super()
	
	create_halo_curve()
	
	grab_released.connect(set_halo_indicator_visibility)


func _process(delta) -> void:
	var _range = halo_curve.sample(halo_time)
	set_tower_range(_range)
	attack_range_indicator_init()
	$HaloIndicator.mesh.inner_radius = _range - 0.3
	$HaloIndicator.mesh.outer_radius = _range
	
	var new_halo_time = halo_time + delta * halo_expansion_direction
	halo_time = clamp(new_halo_time, 0, halo_expansion_time)
	
	if halo_time == halo_expansion_time:
		halo_expansion_direction = -1
	elif halo_time == 0:
		halo_expansion_direction = 1

	attack_cooldown -= delta
	if attack_cooldown <= 0.0 and len(enemies_in_range) != 0 and State.PLACED:

		for enemy in enemies_in_range:
			apply_damage(enemy)

		attacked.emit()
		attack_cooldown = 1.0 / (attacks_per_second * tower_effect_manager.get_attack_speed_modifier())


func apply_damage(target: BaseEnemy) -> void:
	super.apply_damage(target)
	target.enemy_effect_manager.add_effect(HolyBurn.new(target, holy_burn))

func create_halo_curve() -> void:
	var curve = Curve.new()

	curve.max_value = max_range
	curve.min_value = min_range

	curve.max_domain = halo_expansion_time

	curve.add_point(Vector2.ZERO)
	curve.add_point(Vector2(halo_expansion_time, max_range))

	halo_curve = curve


func set_halo_indicator_visibility() -> void:
	if current_state == BaseTower.State.PLACED:
		$HaloIndicator.visible = true
	else:
		$HaloIndicator.visible = false
