extends Node3D
class_name Card

# === State ===
var instance_id: String = ""  # Unique per card copy
var template_id: String = ""  # Static ID from CardData
var card_data: CardData = null
var current_zone: Node3D = null
var zone_type: String = ""
var zone_owner: String = ""
var base_position: Vector3 = Vector3.ZERO
var has_been_played: bool = false

# === Nodes ===
@onready var area: Area3D = get_node_or_null("Area3D")
@onready var sub_viewport: SubViewport = get_node_or_null("SubViewport")

# === Signals ===
signal card_clicked(card: Node3D)
signal card_dropped(card: Node3D, target_zone: Node3D)

# === Lifecycle ===
func _ready() -> void:
	base_position = global_transform.origin
	if area:
		area.monitoring = true
		area.monitorable = true
	call_deferred("apply_card_data")

# === Setup ===
func setup_from_data(_card_data: CardData, zone_node: Node3D, instance_id_in: String = "") -> void:
	reset_state()

	self.card_data = _card_data
	template_id = _card_data.template_id
	instance_id = instance_id_in

	current_zone = zone_node
	zone_type = zone_node.get_meta("zone_type") if zone_node.has_meta("zone_type") else ""
	zone_owner = zone_node.get_meta("owner") if zone_node.has_meta("owner") else ""

	base_position = global_transform.origin
	apply_card_data()


func reset_state() -> void:
	has_been_played = false
	current_zone = null
	template_id = ""
	instance_id = ""
	card_data = null
	zone_type = ""
	zone_owner = ""
	base_position = Vector3.ZERO

# === Interaction ===
func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	var game_ui := get_tree().get_nodes_in_group("GameUI")[0]
	if not game_ui.card_input_enabled:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			card_clicked.emit(self)
		if event.double_click:
			_on_card_double_clicked()

func _on_card_double_clicked() -> void:
	var game_ui := get_tree().get_nodes_in_group("GameUI")[0]
	if not game_ui.card_input_enabled or has_been_played or not current_zone:
		return

	if zone_type == "hand" and zone_owner == "player":
		has_been_played = true
		card_dropped.emit(self, GameContext.player_play_zone)
	elif zone_type == "hand" and zone_owner == "opponent":
		has_been_played = true
		card_dropped.emit(self, GameContext.opponent_play_zone)

# === Visuals ===
func apply_card_data() -> void:
	if not sub_viewport or not card_data:
		return

	var card_ui := sub_viewport.get_child(0)
	if not card_ui:
		return

	var name_label := card_ui.get_node_or_null("NameLabel")
	if name_label and name_label is Label:
		name_label.text = card_data.card_name

	var ability_label := card_ui.get_node_or_null("AbilityLabel")
	if ability_label and ability_label is Label:
		ability_label.text = card_data.description

	var icon := card_ui.get_node_or_null("Icon")
	if icon and icon is TextureRect and card_data.icon_texture:
		icon.texture = card_data.icon_texture

	# Optional: show instance ID for debugging
	var debug_label := card_ui.get_node_or_null("DebugLabel")
	if debug_label and debug_label is Label:
		debug_label.text = instance_id

# === Accessors ===
func get_card_instance_id() -> String:
	return instance_id

func get_template_id() -> String:
	return template_id
