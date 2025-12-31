extends Node3D
class_name DeckZone

# === Debug Toggle ===
@export var debug_enabled: bool = false

func _log(msg: String) -> void:
	if debug_enabled:
		print(msg)

func _warn(msg: String) -> void:
	if debug_enabled:
		push_warning(msg)

@export var zone_owner: String = "player"
@export var stack_direction: Vector3 = Vector3(0, 0.002, -0.005)
@export var card_scale: Vector3 = Vector3(2, 2, 2)

func _ready():
	set_meta("zone_type", "deck")
	set_meta("owner", owner)
	_log("DeckZone ready: %s (%s)" % [name, zone_owner])

# Called by ZoneManager to position a card visually
func layout_card(card: Node3D, index: int) -> void:
	var mesh := get_node_or_null("ZoneMesh")
	if not mesh:
		_warn("ZoneMesh not found in " + name)
		return

	# Position relative to ZoneMesh origin
	var base_pos: Vector3 = mesh.global_transform.origin
	var offset: Vector3 = stack_direction * index

	card.global_transform.origin = base_pos + offset
	card.base_position = card.global_transform.origin
	card.scale = card_scale

	# Rotation based on ownership
	card.rotation_degrees = (
		Vector3(90, 180, 180)
		if zone_owner == "player"
		else Vector3(90, 0, 0)
	)

	card.visible = true

	_log("Laid out card %s at index %d in %s" % [card.name, index, name])
