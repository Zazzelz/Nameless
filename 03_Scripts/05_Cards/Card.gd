extends Node3D

# References to key visual and interaction nodes
@onready var front_face := get_node_or_null("FrontFace")
@onready var sub_viewport := get_node_or_null("SubViewport")
@onready var area := get_node_or_null("Area3D")

# Card data and animation state
var card_data: CardData            # Holds name, description, icon, etc.
var tween: Tween                     # Used for hover animation
var base_position: Vector3           # Anchor position for animation reset
var current_zone: Node3D = null


# Signal emitted when the card is clicked
signal card_clicked(card: Node3D)

func _ready():
	# Apply visuals if data is already set
	if card_data:
		apply_card_data()

	# Store initial position for hover animation
	base_position = global_transform.origin

	# Connect input signal for click detection
	if area:
		area.connect("input_event", Callable(self, "_on_area_input"))
	else:
		push_warning("Area3D not found — card interaction disabled")

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		print("Card received input:", name)

func set_card_data(data: CardData):
	# Assign card data and apply visuals if ready
	card_data = data
	if is_inside_tree():
		apply_card_data()

func apply_card_data():
	# Safely access the UI container inside the SubViewport
	if not sub_viewport:
		push_error("SubViewport not found")
		return

	var card_ui := sub_viewport.get_child(0)
	if not card_ui:
		push_error("CardUI not found inside SubViewport")
		return
		# Optional: skip if data is missing
	if not card_data:
		push_warning("CardData not set — skipping UI update")
		return
	# Update UI elements with card data
	var name_label := card_ui.get_node_or_null("NameLabel")
	var ability_label := card_ui.get_node_or_null("AbilityLabel")
	var icon := card_ui.get_node_or_null("Icon")

	if name_label:
		name_label.text = card_data.card_name
	else:
		push_warning("NameLabel not found in CardUI")

	if ability_label:
		ability_label.text = card_data.description
		ability_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	else:
		push_warning("AbilityLabel not found in CardUI")

	if icon:
		if card_data.icon_texture:
			icon.texture = card_data.icon_texture
	else:
		push_warning("Icon node not found in CardUI")

func _get_property_list():
	return [
		{ name = "card_name", type = TYPE_STRING, usage = PROPERTY_USAGE_EDITOR },
		{ name = "effect_type", type = TYPE_STRING, usage = PROPERTY_USAGE_EDITOR }
	]
func flip_card():
	# Rotate card 180° around Y-axis to simulate flipping
	rotation_degrees.y += 180

func _on_area_3d_mouse_entered() -> void:
	if not is_in_group("player_cards"):
		return
	if current_zone and current_zone.name.ends_with("DeckZone"):
		return # Skip hover in deck zones

	# Animate card upward slightly on hover
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "position", base_position + Vector3(0, 0.2, 0), 0.2)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)

func _on_area_3d_mouse_exited() -> void:
	if not is_in_group("player_cards"):
		return
	if current_zone and current_zone.name.ends_with("DeckZone"):
		return # Skip hover reset in deck zones

	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "position", base_position, 0.2)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN)

func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	## Emit signal when card is clicked
	if event is InputEventMouseButton and event.pressed:
		card_clicked.emit(self)
		print("Card was clicked!")

	#if event is InputEventMouseButton \
	#and event.pressed \
	#and event.button_index == MOUSE_BUTTON_LEFT:
		#print("Card was clicked (left mouse)!")
