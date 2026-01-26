extends Marker3D
class_name PlayZone

# ------------------------------------------------------------------------------
# PlayZone
# Represents the active play area where cards are placed after being played.
# Responsibilities:
# - Maintain zone metadata
# - Stack cards with slight offsets
# - Apply random rotation scatter for natural variation
# ------------------------------------------------------------------------------

@export var zone_owner: String = "player"
@export var stack_direction: Vector3 = Vector3(0, 0.01, 0)
@export var card_scale: Vector3 = Vector3(1.6, 1.6, 1.6)
@export var scatter_rotation_range: float = 5.0


# ------------------------------------------------------------------------------
# Initialization
# ------------------------------------------------------------------------------

func _ready() -> void:
	set_meta("zone_type", "play")
	set_meta("owner", zone_owner)

	DebugTools.log("PlayZone.Init", "PlayZone ready for owner: %s" % zone_owner)


# ------------------------------------------------------------------------------
# Card Layout
# Places cards in a stacked formation with slight random rotation for variety.
# ------------------------------------------------------------------------------

func layout_card(card: Node3D, index: int) -> void:
	var offset: Vector3 = stack_direction * index
	var final_pos: Vector3 = global_transform.origin + offset

	card.global_transform.origin = final_pos
	card.base_position = final_pos
	card.scale = card_scale

	# Face forward relative to world Z
	card.look_at(global_transform.origin + Vector3(0, 0, 1), Vector3.UP)

	# Add subtle random rotation for visual variation
	var random_y: float = randf_range(-scatter_rotation_range, scatter_rotation_range)
	card.rotate_y(deg_to_rad(random_y))

	card.visible = true

	DebugTools.log(
		"PlayZone.Layout",
		"Placed card %s at %s" % [card.name, str(final_pos)]
	)
