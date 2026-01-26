extends RigidBody3D
class_name Dice

# ------------------------------------------------------------------------------
# Dice
# Represents a physics‑driven die. Handles:
# - Rolling and torque impulse
# - Detecting when physics settles
# - Reporting results to GameUI
# - Evaluating which face is upward
# ------------------------------------------------------------------------------

@onready var initial_position: Vector3 = global_position

@export var dice_name: String = "Dice"

var is_rolling: bool = false
var has_reported: bool = false
var can_report: bool = false


# ------------------------------------------------------------------------------
# Roll Trigger
# Resets physics state, applies torque, and begins the roll.
# ------------------------------------------------------------------------------

func roll() -> void:
	is_rolling = true
	has_reported = false
	can_report = true
	sleeping = false

	# Reset transform and velocities
	global_position = initial_position
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO

	# Randomize starting orientation
	rotation_degrees = Vector3(
		randi_range(1, 360),
		randi_range(1, 360),
		randi_range(1, 360)
	)

	# Apply torque to start the roll
	apply_torque_impulse(Vector3.ONE * 0.09)

	DebugTools.log("Dice.Roll", "Dice rolled: %s" % dice_name)


# ------------------------------------------------------------------------------
# Roll Completion Detection
# When the die goes to sleep, report the result once.
# ------------------------------------------------------------------------------

func _process(_delta: float) -> void:
	if sleeping and is_rolling and not has_reported and can_report:
		has_reported = true
		is_rolling = false
		can_report = false

		DebugTools.log(
			"Dice.Roll",
			"Dice finished reporting: %s at frame %d" %
			[dice_name, Engine.get_frames_drawn()]
		)

		var ui := get_tree().get_first_node_in_group("GameUI")
		if ui:
			ui.dice_finished()
		else:
			DebugTools.warn("Dice.Errors", "GameUI not found when reporting dice result")


# ------------------------------------------------------------------------------
# Roll Value Evaluation
# Determines which face is pointing upward based on dot products.
# ------------------------------------------------------------------------------

func get_roll_value() -> int:
	var world_up: Vector3 = Vector3.UP
	var threshold: float = 0.9
	var max_dot: float = -1.0

	# Map each face normal to its corresponding value
	var sides: Dictionary = {
		transform.basis.y: 6,
		-transform.basis.y: 1,
		transform.basis.x: 5,
		-transform.basis.x: 2,
		transform.basis.z: 4,
		-transform.basis.z: 3,
	}

	var value: int = -1

	for side_normal in sides.keys():
		var dot_product := world_up.dot(side_normal.normalized())
		if dot_product > threshold and dot_product > max_dot:
			max_dot = dot_product
			value = sides[side_normal]

	DebugTools.log("Dice.Value", "Dice %s roll value evaluated as %d" % [dice_name, value])
	return value
