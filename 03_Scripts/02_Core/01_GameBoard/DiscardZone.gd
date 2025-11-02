extends Node3D
class_name DiscardZone

func _ready():
	set_meta("zone_type", "discard")
	print("DiscardZone [%s] is ready" % name)

func spawn_card(card: Node3D, index: int):
	var mesh := get_node_or_null("ZoneMesh")
	if not mesh:
		push_warning("ZoneMesh not found in " + name)
		return

	add_child(card)
	card.current_zone = self

	# Base position
	var base_pos: Vector3 = mesh.global_transform.origin


	# Offset each card slightly in Y or Z to stack them visibly
	var offset := Vector3(0, index * 0.002, index * -0.005)

	card.global_transform.origin = base_pos + offset
	card.base_position = card.global_transform.origin
	card.scale = Vector3(1, 1.5, 1.6)

	# Rotation
	var is_player := name.contains("Player")
	if is_player:
		card.rotation_degrees = Vector3(90, 180, 90)
	else:
		card.rotation_degrees = Vector3(90, 0, 0)
	card.visible = true
	
	print("Adding card to zone:", name)
	print("Card parent before add:", card.get_parent())
	#print("Card positioned at:", card.global_transform.origin)
	#print("Card rotation set to:", card.rotation_degrees)
