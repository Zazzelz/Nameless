extends Marker3D
class_name DeckZone

signal deal_requested

@export var zone_owner: String = "player"

# These now apply relative to the DeckZone node itself
@export var card_scale: Vector3 = Vector3(1.4, 1.4, 1.4)
@export var card_rotation: Vector3 = Vector3(90, 180, 0)
@export var stack_offset: Vector3 = Vector3(0, 0.01, 0)

var last_click_time: float = 0.0
var double_click_threshold: float = 0.25


func _ready() -> void:
	set_meta("zone_type", "deck")
	set_meta("owner", zone_owner)
	set_process_input(true)

	DebugTools.log("DeckZone.Init", "DeckZone ready for owner: %s" % zone_owner)


# ------------------------------------------------------------------------------
# Card Layout (table‑relative)
# ------------------------------------------------------------------------------

func layout_cards() -> void:
	var index := 0
	for child in get_children():
		if child is Card:
			layout_card(child, index)
			index += 1


func layout_card(card: Node3D, index: int) -> void:
	# Base position is now the DeckZone's own transform (world‑space)
	var base_pos := global_transform.origin

	# Apply stacking offset
	card.global_transform.origin = base_pos + stack_offset * index

	# Rotation: opponent deck faces the player
	if zone_owner == "opponent":
		card.rotation_degrees = Vector3(
			card_rotation.x,
			card_rotation.y + 180,
			card_rotation.z
		)
	else:
		card.rotation_degrees = card_rotation

	card.scale = card_scale
	card.visible = true

	DebugTools.log("DeckZone.Layout", "Laid out %s at %d" % [card.name, index])


# ------------------------------------------------------------------------------
# Input Handling (double‑click detection)
# ------------------------------------------------------------------------------

func _input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton):
		return
	if event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
		return

	var now := Time.get_ticks_msec() / 1000.0
	var delta := now - last_click_time

	DebugTools.log("DeckZone.Input", "Click detected (Δ=%.3f)" % delta)

	if delta <= double_click_threshold:
		DebugTools.log("DeckZone.Input", "Double-click candidate")
		_on_double_click()

	last_click_time = now


func _on_double_click() -> void:
	if zone_owner != "player":
		DebugTools.log("DeckZone.Input", "Ignored double click (not player deck)")
		return

	if not _is_mouse_over_deck():
		DebugTools.log("DeckZone.Input", "Double click ignored (mouse not over deck)")
		return

	DebugTools.log("DeckZone.Input", "Deck double-clicked → deal_requested emitted")
	emit_signal("deal_requested")


# ------------------------------------------------------------------------------
# Raycast Check (still works perfectly in world‑space)
# ------------------------------------------------------------------------------

func _is_mouse_over_deck() -> bool:
	var cam := get_viewport().get_camera_3d()
	if cam == null:
		DebugTools.warn("DeckZone.Errors", "No camera for raycast")
		return false

	var mouse_pos := get_viewport().get_mouse_position()
	var from := cam.project_ray_origin(mouse_pos)
	var to := from + cam.project_ray_normal(mouse_pos) * 100.0

	var query := PhysicsRayQueryParameters3D.new()
	query.from = from
	query.to = to
	query.collide_with_areas = true

	var result := get_world_3d().direct_space_state.intersect_ray(query)

	if not result:
		DebugTools.log("DeckZone.Raycast", "Raycast missed")
		return false

	var collider: Node = result.get("collider")

	while collider:
		if collider == self:
			DebugTools.log("DeckZone.Raycast", "Ray hit DeckZone")
			return true
		if collider.has_meta("zone_type") and collider.get_meta("zone_type") == "deck":
			DebugTools.log("DeckZone.Raycast", "Ray hit deck-owned node")
			return true
		collider = collider.get_parent()

	DebugTools.log("DeckZone.Raycast", "Ray hit non-deck object")
	return false
