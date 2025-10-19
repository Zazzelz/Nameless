extends Area3D
class_name PlayZone

@export var zone_owner: String = "player" # or "opponent"
@onready var player_play_zone: PlayZone = $"."

func _ready():
	print("PlayZone [%s] is ready" % zone_owner)
	set_meta("zone_type", "play")
	set_meta("zone_owner", zone_owner)
	set_meta("zone_ref", self)

func spawn_card(card: Node3D, index: int):
	var mesh := get_node_or_null("ZoneMesh")
	if not mesh:
		push_warning("ZoneMesh not found in " + name)
		return

	add_child(card)
	card.current_zone = self

	# Base position
	var base_pos: Vector3 = mesh.global_transform.origin

	# Offset each card slightly in Y and Z to simulate stacking
	var vertical_offset := index * 0.002
	var depth_offset := index * -0.005
	var final_pos := base_pos + Vector3(0.0, vertical_offset, depth_offset)

	card.global_transform.origin = final_pos
	card.base_position = final_pos
	card.scale = Vector3(1, 1.5, 1.6)

	# ✅ Random Y rotation for natural scatter
	var random_y_rotation := randf_range(-15.0, 15.0)

	# ✅ Face-up orientation with long edge aligned correctly
	# Assumes card mesh is long along X and front face points +Z
	card.rotation_degrees = Vector3(-90, random_y_rotation, 90)

	card.visible = true

	# Debug output
	print("Card placed at:", final_pos)
	print("Rotation Y:", random_y_rotation)
