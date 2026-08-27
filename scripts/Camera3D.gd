extends Node3D

@export var move_speed := 20.0
@export var rotate_speed := 1.0
@export var zoom_speed := 10
@export var min_size := 2.0
@export var max_size := 50.0

@export var camera : Camera3D

func _ready() -> void:
	assert(camera != null)


func _process(delta):
	_move_camera(delta)
	_rotate_camera(delta)
	_zoom_camera(delta)


func _move_camera(delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("ui_up"):      # W
		direction -= camera.global_transform.basis.z
	if Input.is_action_pressed("ui_down"):    # S
		direction += camera.global_transform.basis.z
	if Input.is_action_pressed("ui_left"):    # A
		direction -= camera.global_transform.basis.x
	if Input.is_action_pressed("ui_right"):   # D
		direction += camera.global_transform.basis.x

	direction.y = 0

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		global_position += direction * move_speed * delta


func _rotate_camera(delta):
	var yaw_input = 0.0

	if Input.is_action_pressed("rotate_left"):
		yaw_input += 1
	if Input.is_action_pressed("rotate_right"):
		yaw_input -= 1

	if yaw_input != 0.0:
		rotate_y(yaw_input * rotate_speed * delta)


func _zoom_camera(delta) -> void:
	var zoom_input = 0.0
	
	if Input.is_action_just_pressed("zoom_in"):
		zoom_input += 1
	if Input.is_action_just_pressed("zoom_out"):
		zoom_input -= 1

	if zoom_input != 0.0:
		camera.size = clamp(camera.size + zoom_input, min_size, max_size)
