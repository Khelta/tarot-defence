extends BaseTower
class_name Ranger

func _ready() -> void:
	pass


func _process(delta):
	pass

func set_viewport_camera(camera_position: Vector3) -> void:
	get_node("BaseTower").set_viewport_camera(camera_position)
