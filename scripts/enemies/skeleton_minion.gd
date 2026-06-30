extends Node3D

func _ready() -> void:
	get_node("SkeletonMinionModel").get_node("AnimationPlayer").play("Running_B")


func _on_base_enemy_enemy_died() -> void:
	get_node("HealthBarViewPort/HealthBar").queue_free()
	
	var animation_player = get_node("SkeletonMinionModel").get_node("AnimationPlayer")
	animation_player.play("Rig_Medium_General/Death_A")
	await animation_player.animation_finished
	
	await get_tree().create_timer(2).timeout
	
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y - 3, 1.0)
	
	await get_tree().create_timer(1).timeout
	
	get_parent().queue_free()
