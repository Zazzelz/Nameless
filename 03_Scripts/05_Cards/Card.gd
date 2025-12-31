extends Node3D
class_name Card

# === Debug Toggle ===
@export var debug_enabled: bool = false

func _log(msg: String) -> void:
	if debug_enabled:
		print(msg)

func _warn(msg: String) -> void:
	if debug_enabled:
		push_warning(msg)

# === State ===
var instance_id: String = ""
var template_id: String = ""
var card_data: CardData = null
var current_zone: Node3D = null
var zone_type: String = ""
var zone_owner: String = ""
var has_been_played: bool = false

# === Nodes ===
@onready var area: Area3D = get_node_or_null("Area3D")
@onready var sub_viewport: SubViewport = get_node_or_null("SubViewport")

# === Signals ===
signal card_clicked(card: Card)
signal card_dropped(card: Card, target_zone: Node3D)

# === Lifecycle ===
func _ready() -> void:
	if area:
		area.monitoring = true
		area.monitorable = true

	# Defer UI application until viewport is ready
	call_deferred("_apply_ui_when_ready")


# === Setup ===
func setup_from_data(_card_data: CardData, zone_node: Node3D = null, instance_id_in: String = "") -> void:
	reset_state()

	card_data = _card_data
	template_id = _card_data.template_id
	instance_id = instance_id_in

	current_zone = zone_node
	zone_type = zone_node.get_meta("zone_type") if zone_node and zone_node.has_meta("zone_type") else ""
	zone_owner = zone_node.get_meta("owner") if zone_node and zone_node.has_meta("owner") else ""


func reset_state() -> void:
	has_been_played = false
	current_zone = null
	template_id = ""
	instance_id = ""
	card_data = null
	zone_type = ""
	zone_owner = ""


# === Guaranteed UI Application ===
func _apply_ui_when_ready() -> void:
	# Wait until SubViewport exists
	if not sub_viewport:
		await get_tree().process_frame
		sub_viewport = get_node_or_null("SubViewport")

	if not sub_viewport:
		_warn("Card: SubViewport never became ready")
		return

	# Wait until CardUi exists inside the viewport
	var card_ui := sub_viewport.get_node_or_null("CardUi")
	var attempts := 0

	while not card_ui and attempts < 10:
		await get_tree().process_frame
		card_ui = sub_viewport.get_node_or_null("CardUi")
		attempts += 1

	if not card_ui:
		_warn("Card: CardUi never appeared inside SubViewport")
		return

	apply_card_data()


# === Visuals ===
func apply_card_data() -> void:
	if not card_data:
		_warn("Card: apply_card_data() called with no card_data")
		return

	var card_ui := sub_viewport.get_node_or_null("CardUi")
	if not card_ui:
		_warn("Card: CardUi missing at apply time")
		return

	var name_label: Label = card_ui.get_node_or_null("NameLabel")
	var ability_label: Label = card_ui.get_node_or_null("AbilityLabel")
	var icon: TextureRect = card_ui.get_node_or_null("Icon")
	var debug_label: Label = card_ui.get_node_or_null("DebugLabel")

	if name_label:
		name_label.text = card_data.card_name
	if ability_label:
		ability_label.text = card_data.description
	if icon and card_data.icon_texture:
		icon.texture = card_data.icon_texture
	if debug_label:
		debug_label.text = instance_id

	_log("Card UI applied: %s" % card_data.card_name)


# === Interaction ===
func _on_area_3d_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			card_clicked.emit(self)
		if event.double_click:
			_on_card_double_clicked()


func _on_card_double_clicked() -> void:
	if has_been_played or not current_zone:
		return

	if zone_type == "hand" and zone_owner == "player":
		has_been_played = true
		card_dropped.emit(self, GameContext.player_play_zone)
	elif zone_type == "hand" and zone_owner == "opponent":
		has_been_played = true
		card_dropped.emit(self, GameContext.opponent_play_zone)
