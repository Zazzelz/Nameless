extends Area3D
class_name PlayZone

# === Debug Toggle ===
@export var debug_enabled: bool = false

func _log(msg: String) -> void:
	if debug_enabled:
		print(msg)

func _warn(msg: String) -> void:
	if debug_enabled:
		push_warning(msg)

@export var zone_owner: String = "player" # "player" or "opponent"
@export var stack_direction: Vector3 = Vector3(0, 0.002, -0.005)
@export var card_scale: Vector3 = Vector3(1, 1.5, 1.6)
@export var scatter_rotation_range: float = 15.0

func _ready() -> void:
	set_meta("zone_type", "play")
	set_meta("owner", zone_owner)
	set_meta("zone_ref", self)
	_log("PlayZone [%s] is ready" % zone_owner)

# Called by ZoneManager to visually position a card
func layout_card(card: Node3D, index: int) -> void:
	var mesh: Node3D = get_node_or_null("ZoneMesh")
	if not mesh:
		_warn("ZoneMesh not found in " + name)
		return

	var base_pos: Vector3 = mesh.global_transform.origin
	var offset: Vector3 = stack_direction * index
	var final_pos: Vector3 = base_pos + offset

	card.global_transform.origin = final_pos
	card.base_position = final_pos
	card.scale = card_scale

	var random_y_rotation: float = randf_range(-scatter_rotation_range, scatter_rotation_range)
	card.rotation_degrees = Vector3(-90, random_y_rotation, 90)
	card.visible = true

	var mesh_node: Node3D = card.get_node_or_null("FrontFace")
	if mesh_node:
		mesh_node.scale = Vector3.ONE
		mesh_node.rotation_degrees = Vector3.ZERO

	_log("Card placed at %s" % str(final_pos))
	_log("Rotation Y: %f" % random_y_rotation)
