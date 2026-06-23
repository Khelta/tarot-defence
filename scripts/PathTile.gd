extends Node3D

@export var objects: Array[PackedScene]

func _ready():
	add_path_object()

func add_path_object():
	if objects.is_empty():
		return
		
	var random_object = objects[randi() % objects.size()]
	var rotation = (randi() % 4) * 90
	var obj = random_object.instantiate()
	obj.rotation_degrees += Vector3(obj.rotation_degrees.x, obj.rotation_degrees.y + rotation, obj.rotation_degrees.z)
	
	add_child(obj)
