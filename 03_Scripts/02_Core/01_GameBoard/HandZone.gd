extends Node3D
class_name HandZone

func _ready():
	set_meta("zone_type", "hand")

func spawn_card(card: Node3D, _index: int):
	card.current_zone = self
	add_child(card)

	# Count existing cards (excluding ZoneMesh)
	var card_index := 0
	for child in get_children():
		if child.get_class() == "Node3D" and child.has_method("set_card_data") and child.name != "ZoneMesh":
			card_index += 1
	card_index = max(0, card_index - 1)

	# Anchor position
	var anchor := get_node_or_null("ZoneMesh")
	var anchor_global_pos: Vector3 = anchor.global_transform.origin if anchor else global_transform.origin


	# Layout offset
	var spacing := -0.4
	var z_offset := 1.0
	var card_global_pos := anchor_global_pos + Vector3(0, -0.123, card_index * spacing + z_offset)

	# Transform and visual reset
	card.set_as_top_level(true)
	card.global_transform.origin = card_global_pos
	card.scale = Vector3(0.3, 0.5, 0.5)
	card.rotation_degrees = Vector3(0, 90, 0)

	# Reset mesh if needed
	var card_mesh := card.get_node_or_null("FrontFace")
	if card_mesh:
		card_mesh.scale = Vector3.ONE
		card_mesh.rotation_degrees = Vector3.ZERO
	else:
		print("FrontFace not found in", card.name)

	card.base_position = card_global_pos

	print("HandZone: Spawned card", card.name, "at", card_global_pos)
