extends Node3D
class_name DiscardZone

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

func _ready():
	set_meta("zone_type", "discard")
	set_meta("owner", zone_owner)
	_log("DiscardZone [%s] is ready" % name)

# Called by ZoneManager to visually position a card
func layout_card(card: Node3D, index: int) -> void:
	var mesh := get_node_or_null("ZoneMesh")
	if not mesh:
		_warn("ZoneMesh not found in " + name)
		return

	var base_pos: Vector3 = mesh.global_transform.origin
	var offset: Vector3 = stack_direction * index

	card.global_transform.origin = base_pos + offset
	card.base_position = card.global_transform.origin
	card.scale = card_scale

	card.rotation_degrees = (
		Vector3(90, 180, 90)
		if zone_owner == "player"
		else Vector3(90, 0, 0)
	)

	card.visible = true

	_log("Laid out card %s at index %d in discard zone %s" %
		[card.name, index, name])
