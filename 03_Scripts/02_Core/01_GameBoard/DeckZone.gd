extends Node3D

func _ready():
	set_meta("zone_type", "deck")

func spawn_card(card: Node3D, _index: int):
	var mesh := get_node_or_null("ZoneMesh")
	card.current_zone = self
	
	if not mesh:
		push_warning("ZoneMesh not found in " + name)
		return

	add_child(card)

	# Position card at mesh center (world space)
	card.global_transform.origin = mesh.global_transform.origin
	card.base_position = card.global_transform.origin
	card.scale = Vector3(2, 2, 2)
	
	# Apply rotation based on zone identity
	match name:
		"PlayerDeckZone":
			card.rotation_degrees = Vector3(90, 180, 180)
		"OpponentDeckZone":
			card.rotation_degrees = Vector3(90, 0, 0)
		_:
			card.rotation_degrees = Vector3(90, 180, 180) # Default fallback

	print("Card positioned at:", card.global_transform.origin)
	print("Card rotation set to:", card.rotation_degrees)
