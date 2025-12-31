extends RigidBody3D

# === Debug Toggle ===
@export var debug_enabled: bool = false

func _log(msg: String) -> void:
	if debug_enabled:
		print(msg)

func _warn(msg: String) -> void:
	if debug_enabled:
		push_warning(msg)

@onready var initial_position = global_position

@export var dice_name: String = "Dice"
var is_rolling: bool = false
var has_reported: bool = false
var can_report: bool = false

func roll():
	is_rolling = true
	has_reported = false
	can_report = true
	sleeping = false

	global_position = initial_position
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO

	rotation_degrees = Vector3(
		randi_range(1, 360),
		randi_range(1, 360),
		randi_range(1, 360)
	)

	apply_torque_impulse(Vector3.ONE * 0.09)
	_log("Dice rolled: %s" % dice_name)

func _process(_delta):
	if sleeping and is_rolling and not has_reported and can_report:
		has_reported = true
		is_rolling = false
		can_report = false

		_log("Dice finished reporting: %s at frame %d" %
			[dice_name, Engine.get_frames_drawn()])

		var ui := get_tree().get_first_node_in_group("GameUI")
		if ui:
			ui.dice_finished()
		else:
			_warn("GameUI not found when reporting dice result")

func get_roll_value():
	var world_up = Vector3.UP
	var threshold = 0.9
	var max_dot = -1

	var sides = {
		transform.basis.y: 6,
		-transform.basis.y: 1,
		transform.basis.x: 5,
		-transform.basis.x: 2,
		transform.basis.z: 4,
		-transform.basis.z: 3,
	}

	var value = -1
	for side in sides:
		var dot_product = world_up.dot(side.normalized())
		if dot_product > threshold and dot_product > max_dot:
			max_dot = dot_product
			value = sides[side]

	_log("Dice %s roll value evaluated as %d" % [dice_name, value])
	return value
