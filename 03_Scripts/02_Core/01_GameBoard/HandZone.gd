extends Node3D
class_name HandZone

@export var hand_offset: Vector3 = Vector3(0, -1.6, 5)  # Used for camera_fan layout
@export var anchor_node: Node3D                         # Optional override for anchoring
@export var layout_mode: String = "camera_fan"          # "camera_fan" or "zone_offset"

func _ready() -> void:
	set_meta("zone_type", "hand")

func _process(_delta: float) -> void:
	if layout_mode == "camera_fan":
		var anchor := anchor_node if anchor_node else get_viewport().get_camera_3d()
		if anchor:
			global_transform.origin = anchor.global_transform.origin + hand_offset
			look_at(anchor.global_transform.origin, Vector3.UP)

func spawn_card(card: Node3D, _index: int) -> void:
	card.current_zone = self
	add_child(card)

	match layout_mode:
		"camera_fan":
			_spawn_camera_fan_layout()
		"zone_offset":
			_spawn_zone_centered_layout()
		_:
			push_warning("Unknown layout_mode: %s" % layout_mode)

func _spawn_camera_fan_layout() -> void:
	var anchor := anchor_node if anchor_node else get_viewport().get_camera_3d()
	if not anchor:
		push_error("No anchor found for camera_fan layout")
		return

	var spread := 0.2
	var right := anchor.global_transform.basis.x.normalized()
	var forward := -anchor.global_transform.basis.z.normalized()
	var base := anchor.global_transform.origin + forward * 1.0 + Vector3(0.08, hand_offset.y + 1.0, 0)

	var card_nodes := get_children().filter(
		func(c): return c is Node3D and c.has_method("set_card_data")
	)
	var total_cards := card_nodes.size()

	for i in range(total_cards):
		var offset := 0.0
		if total_cards % 2 == 1:
			var center := (total_cards - 1) / 2
			offset = (i - center) * spread
		else:
			var center := total_cards / 2.0
			offset = (i - center + 0.5) * spread

		var card_pos := base + right * offset
		var c: Node3D = card_nodes[i]
		c.set_as_top_level(true)
		c.global_transform.origin = card_pos

		var anchor_yaw := anchor.global_transform.basis.get_euler().y
		var tilt := deg_to_rad(-20)
		c.rotation = Vector3(tilt, anchor_yaw, 0)

		c.scale = Vector3(0.3, 0.5, 0.5)
		c.base_position = card_pos

		var card_mesh := c.get_node_or_null("FrontFace")
		if card_mesh:
			card_mesh.scale = Vector3.ONE
			card_mesh.rotation_degrees = Vector3.ZERO

func _spawn_zone_centered_layout() -> void:
	var card_global_pos: Vector3 = Vector3(0, 2, 0)  # Spawn at center for visibility

	var card := get_children().back() as Node3D
	card.set_as_top_level(true)
	card.global_transform.origin = card_global_pos
	card.scale = Vector3(0.3, 0.5, 0.5)
	card.rotation_degrees = Vector3(0, 90, 0)

	var card_mesh := card.get_node_or_null("FrontFace")
	if card_mesh:
		card_mesh.scale = Vector3.ONE
		card_mesh.rotation_degrees = Vector3.ZERO

	card.base_position = card_global_pos

	print("HandZone: Spawned card %s at %s" % [card.name, card_global_pos])

func has_cards() -> bool:
	return get_children().any(
		func(c): return c is Node3D and c.has_method("set_card_data")
	)
	
func shift_hand_backwards(offset: float = -1.5):
	for card in get_children():
		# Only shift cards that are actual Card.gd instances and not being dragged
		if card is Node3D and "is_dragging" in card and not card.is_dragging:
			var tween := create_tween()
			var new_pos: Vector3 = card.global_transform.origin + Vector3(0, 0, offset)
			tween.tween_property(card, "global_transform:origin", new_pos, 0.3)

func reset_hand_positions():
	for card in get_children():
		if card is Node3D:
			var tween := create_tween()
			tween.tween_property(card, "global_transform:origin", card.base_position, 0.3)
