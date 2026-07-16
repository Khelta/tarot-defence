extends Node3D

var booster_pack : Node3D

func _ready() -> void:
	booster_pack = get_node("BoosterPack")

func _process(delta: float) -> void:
	booster_pack.rotate_y(0.01)
