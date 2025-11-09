extends Node3D
class_name HandZone

@export var zone_owner: String = "player" # "player" or "opponent"
@export var layout_mode: String = "camera_fan" # or "zone_offset"
@export var hand_offset: Vector3 = Vector3(0, -1.6, 5)
@export var anchor_node: Node3D
@export var card_scale: Vector3 = Vector3(0.3, 0.5, 0.5)
@export var spread: float = 0.2

func _ready() -> void:
	set_meta("zone_type", "hand")
	set_meta("owner", zone_owner)

func layout_hand() -> void:
	match layout_mode:
		"camera_fan":
			_layout_camera_fan()
		"zone_offset":
			_layout_zone_centered()
		_:
			push_warning("Unknown layout_mode: %s" % layout_mode)

func _layout_camera_fan() -> void:
	var anchor := anchor_node if anchor_node else get_viewport().get_camera_3d()
	if not anchor:
		push_error("No anchor found for camera_fan layout")
		return

	var right := anchor.global_transform.basis.x.normalized()
	var forward := -anchor.global_transform.basis.z.normalized()
	var base := anchor.global_transform.origin + forward * 1.0 + Vector3(0.08, hand_offset.y + 1.0, 0)

	var cards: Array[Node3D] = get_children().filter(func(c): return c is Node3D and c.has_method("set_card_data"))
	var total := cards.size()

	for i in range(total):
		var offset := (i - (total - 1) / 2.0) * spread
		var pos := base + right * offset
		var card := cards[i]

		card.set_as_top_level(true)
		card.global_transform.origin = pos
		card.base_position = pos
		card.scale = card_scale
		card.rotation = Vector3(deg_to_rad(-20), anchor.global_transform.basis.get_euler().y, 0)

		var mesh := card.get_node_or_null("FrontFace")
		if mesh:
			mesh.scale = Vector3.ONE
			mesh.rotation_degrees = Vector3.ZERO

func _layout_zone_centered() -> void:
	var cards: Array[Node3D] = get_children().filter(func(c): return c is Node3D and c.has_method("set_card_data"))
	if cards.is_empty():
		return

	var pos := global_transform.origin + Vector3(0, 2, 0)
	var card: Node3D = cards.back()

	card.set_as_top_level(true)
	card.global_transform.origin = pos
	card.base_position = pos
	card.scale = card_scale
	card.rotation_degrees = Vector3(0, 90, 0)

	var mesh: MeshInstance3D = card.get_node_or_null("FrontFace")

	if mesh:
		mesh.scale = Vector3.ONE
		mesh.rotation_degrees = Vector3.ZERO

func shift_hand_backwards(offset: float = -1.5) -> void:
	for card in get_children():
		if card is Node3D and card.has_method("is_dragging") and not card.is_dragging():
			var tween := create_tween()
			var new_pos: Vector3 = card.global_transform.origin + Vector3(0, 0, offset)
			tween.tween_property(card, "global_transform:origin", new_pos, 0.3)

func reset_hand_positions() -> void:
	for card in get_children():
		if card is Node3D and card.has_method("base_position"):
			var tween := create_tween()
			tween.tween_property(card, "global_transform:origin", card.base_position, 0.3)

func has_cards() -> bool:
	return get_children().any(func(c): return c is Node3D and c.has_method("set_card_data"))
