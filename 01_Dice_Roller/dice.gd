extends RigidBody3D

@onready var initial_position = global_position
@onready var player_result_label = $"../GameManager/PlayerRollResult"
@onready var opponent_result_label = $"../GameManager/OpponentRollResult"
@onready var result_label = $"../GameManager/GameResult"

@export var dice_name: String = "Dice"
var is_rolling: bool = false
var has_reported: bool = false
var can_report: bool = false

func roll():
	is_rolling = true
	has_reported = false
	can_report = true  # now this die can report
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

func _process(delta):
	if sleeping and is_rolling and not has_reported and can_report:
		has_reported = true
		is_rolling = false
		can_report = false
		print("Dice finished reporting: ", dice_name, " at frame: ", Engine.get_frames_drawn())
		# Notify GameManager to check results
		get_tree().get_first_node_in_group("Game_Manager").dice_finished()

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
	return value
