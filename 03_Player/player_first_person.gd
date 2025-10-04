extends CharacterBody3D

@onready var camera_3d: Camera3D = $Camera3D

var free_camera := true
var look_sensitivity := 0.008
var rotation_x := 0.0
var rotation_y := 0.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	# Optional manual toggle (for testing until TurnManager exists)
	if event.is_action_pressed("toggle_mode"):
		toggle_camera_mode()

func _process(delta: float) -> void:
	if free_camera:
		handle_camera_input(delta)

func handle_camera_input(delta: float) -> void:
	var mouse_motion := Input.get_last_mouse_velocity()
	rotation_y -= mouse_motion.x * look_sensitivity * delta
	rotation_x -= mouse_motion.y * look_sensitivity * delta
	rotation_x = clamp(rotation_x, deg_to_rad(-70), deg_to_rad(70))

	# Apply yaw (left/right) to the player body
	rotation.y = rotation_y
	# Apply pitch (up/down) to the camera only
	camera_3d.rotation.x = rotation_x

func toggle_camera_mode():
	free_camera = !free_camera
	if free_camera:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		print("Free camera enabled")
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		print("Free camera disabled (card mode)")
