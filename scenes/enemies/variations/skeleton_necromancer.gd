extends BaseEnemy
class_name SkeletonNecromancer

func _ready() -> void:
	is_caster = true
	cast_cooldown = 2.0
	cast_duration = 3.0

	animation_class = get_node("Model") as SkeletonNecromancerAnimation
	begined_casting.connect(animation_class._casting)
	casting_finished.connect(animation_class._on_cast_finished)

	super._ready()

	animation_player.play("Running_B")


func death_animation(_no_value: int) -> void:
	get_node("HealthBarViewPort/HealthBar").queue_free()
	
	animation_player.play("Rig_Medium_General/Death_A")
	await animation_player.animation_finished
	
	await get_tree().create_timer(2).timeout
	
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y - 3, 1.0)
	
	await get_tree().create_timer(1).timeout
	
	get_parent().queue_free()


func cast_spell() -> void:
	for i in range(0, 2):
		var enemy_instance = EnemyUtils.enemy_scenes_dict["s"].instantiate()
		enemy_spawned.emit(enemy_instance)
