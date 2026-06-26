@tool
extends Node3D

@export var is_placeable: bool = true:
	set(new_is_placeable):
		is_placeable = new_is_placeable
		set_material()
@export var tower: Node3D


func _ready() -> void:
	set_material()


func set_material() -> void:
	const default_material = null
	const non_placeable_material = preload("res://materials/invalid_placeable_material.tres")
	var floor_mesh = get_child(0)
	
	if is_placeable:
		floor_mesh.set_surface_override_material(0, default_material)
	else:
		floor_mesh.set_surface_override_material(0, non_placeable_material)
