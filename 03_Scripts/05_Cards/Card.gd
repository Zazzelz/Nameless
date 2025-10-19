extends Node3D
class_name Card

# Zone tracking
var current_zone: Node3D

# Unique identifier for this card instance (mirrors card_data.id)
var card_id: String

# Card identity and state
var card_data: CardData
var base_position: Vector3
var has_been_played := false

# Interaction nodes
@onready var area := get_node_or_null("Area3D")
@onready var sub_viewport := get_node_or_null("SubViewport")

# Signals for interaction
signal card_clicked(card: Node3D)
signal card_dropped(card: Node3D, target_zone: Node3D)

func _ready():
	# Initialize card visuals and input monitoring
	base_position = global_transform.origin
	if area:
		area.monitoring = true
		area.monitorable = true
	call_deferred("apply_card_data")

func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int):
	var game_ui := get_tree().get_nodes_in_group("GameUI")[0]
	if not game_ui.card_input_enabled:
		print("Card input is disabled during this phase.")
		return
	
	# Handles mouse click and double-click events
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var zone_name: String
			if current_zone:
				zone_name = current_zone.name
			else:
				zone_name = "None"
			print("Card clicked: %s | Zone: %s" % [name, zone_name])
			card_clicked.emit(self)
		if event.double_click:
			_on_card_double_clicked()

func _on_card_double_clicked():
	var game_ui := get_tree().get_nodes_in_group("GameUI")[0]
	if not game_ui.card_input_enabled:
		print("Card input is disabled during this phase.")
		return
	# Emits card_dropped signal if card is in a hand zone and hasn't been played
	if not current_zone:
		print("Double-click ignored — current_zone is null")
		return
	if has_been_played:
		print("Double-click ignored — card already played:", name)
		return

	print("Card double-clicked:", name, "| Zone:", current_zone.name)
	has_been_played = true

	# ✅ Use GameContext instead of assuming current_scene has play zones
	if current_zone.name == "PlayerHandZone":
		card_dropped.emit(self, GameContext.player_play_zone)
	elif current_zone.name == "OpponentHandZone":
		card_dropped.emit(self, GameContext.opponent_play_zone)
	else:
		print("Double-click ignored — card not in hand zone")

func set_card_data(data: CardData):
	# Assigns card data and applies visuals if ready
	card_data = data
	card_id = data.id
	if is_inside_tree():
		apply_card_data()

func apply_card_data():
	# Updates the card's visual UI elements (name, description, icon) based on its assigned CardData.
	if not sub_viewport or not card_data:
		return

	var card_ui := sub_viewport.get_child(0)
	if not card_ui:
		return

	var name_label = card_ui.get_node_or_null("NameLabel")
	if name_label:
		name_label.text = card_data.card_name

	var ability_label = card_ui.get_node_or_null("AbilityLabel")
	if ability_label:
		ability_label.text = card_data.description

	var icon = card_ui.get_node_or_null("Icon")
	if icon and card_data.icon_texture:
		icon.texture = card_data.icon_texture
