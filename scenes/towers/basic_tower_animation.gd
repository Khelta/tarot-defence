extends Node
class_name BasicTowerAnimation

@export var animation_player : AnimationPlayer
@export var idle_animation_path : String

func _ready() -> void:
	assert(animation_player != null)
	assert(idle_animation_path != null)
	_idle()


func _idle() -> void:
	set_animation_on_loop(idle_animation_path)
	animation_player.play(idle_animation_path)


func _attack() -> void:
	_idle()

func _on_grab() -> void:
	animation_player.play("Jump_Start")
	await animation_player.animation_finished
	set_animation_on_loop("Jump_Idle")
	animation_player.play("Jump_Idle")
	

func _on_grab_released() -> void:
	animation_player.play("Jump_Land", 1)
	await animation_player.animation_finished
	_idle()

func set_animation_on_loop(animation_name: String) -> void: 
	var anim : Animation = animation_player.get_animation(animation_name)
	anim.loop_mode = (Animation.LOOP_LINEAR)


func _on_base_tower_attack() -> void:
	_attack()


func _set_selection(is_on: bool) -> void:
	var mat = ShaderMaterial.new()
	mat.shader = preload("res://materials/shader/fresnel.gdshader")
	
	for ranger_mesh in get_node("Rig_Medium/Skeleton3D").get_children():
		if ranger_mesh is MeshInstance3D:
			ranger_mesh.material_overlay = mat if is_on else null
