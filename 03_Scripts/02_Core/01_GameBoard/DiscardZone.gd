extends Marker3D
class_name DiscardZone

# ------------------------------------------------------------------------------
# DiscardZone
# Represents the discard pile for a player or opponent.
# Responsibilities:
# - Maintain zone metadata
# - Stack cards visually in a simple vertical or directional offset
# - Apply consistent scale and orientation to discarded cards
# ------------------------------------------------------------------------------

@export var zone_owner: String = "player"
@export var stack_direction: Vector3 = Vector3(0, 0.01, 0)
@export var card_scale: Vector3 = Vector3(1.4, 1.4, 1.4)


# ------------------------------------------------------------------------------
# Initialization
# ------------------------------------------------------------------------------

func _ready() -> void:
	set_meta("zone_type", "discard")
	set_meta("owner", zone_owner)

	DebugTools.log("DiscardZone.Init", "DiscardZone ready for owner: %s" % zone_owner)


# ------------------------------------------------------------------------------
# Card Layout
# Positions cards in a simple stacked formation based on index.
# ------------------------------------------------------------------------------

func layout_card(card: Node3D, index: int) -> void:
	var offset: Vector3 = stack_direction * index

	card.global_transform.origin = global_transform.origin + offset
	card.base_position = card.global_transform.origin

	card.scale = card_scale
	card.global_transform.basis = global_transform.basis
	card.visible = true

	DebugTools.log(
		"DiscardZone.Layout",
		"Laid out card %s at index %d" % [card.name, index]
	)
