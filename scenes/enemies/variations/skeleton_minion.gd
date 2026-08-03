extends BaseEnemy
class_name SkeletonMinion

func _ready() -> void:
	animation_class = get_node("Model")

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
