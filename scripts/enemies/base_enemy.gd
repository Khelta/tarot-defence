extends Node3D

@export var max_hp: float = 100.0
@export var speed: float = 20.0

var current_hp: float = max_hp

signal hp_changed(current_hp, max_hp)
	
func _ready() -> void:
	hp_changed.emit(current_hp, max_hp)

func take_damage(amount: float):
	current_hp -= amount
	hp_changed.emit(current_hp, max_hp)
