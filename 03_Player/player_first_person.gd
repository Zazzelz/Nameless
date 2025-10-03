extends CharacterBody3D


@onready var Camera_3d = $Camera3D

const SPEED = 5.0
const JUMO_VELOCITY = 4.5
const CAMERA_SENS = 0.008

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if event.is_action_pressed("Quit"): get_tree().quit()
	
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * CAMERA_SENS
		rotation.x -= event.relative.y * CAMERA_SENS
		
func _physics_process(delta: float) -> void:
	pass
	
