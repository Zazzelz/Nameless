extends Node3D
class_name Card

# --- Card State ---
var instance_id: String = ""
var template_id: String = ""
var card_data: CardData = null

var current_zone: Node3D = null
var zone_type: String = ""
var zone_owner: String = ""
var has_been_played: bool = false

var current_zone_key: String = ""

@export var move_speed := 12.0
@export var rotate_speed := 12.0
@export var default_height: float = 0.15

# --- Hover Settings ---
var is_hovered := false
@export var hover_lift := 0.2      # base lift in world units

# --- Node References ---
@onready var area: Area3D = get_node_or_null("Area3D")
@onready var sub_viewport: SubViewport = get_node_or_null("SubViewport")

# --- Signals ---
signal card_clicked(card: Card)
signal card_dropped(card: Card, target_zone: Node3D)

# ------------------------------------------------------------------------------

func _ready() -> void:
	if area:
		area.monitoring = true
		area.monitorable = true
		area.connect("mouse_entered", Callable(self, "_on_hover_entered"))
		area.connect("mouse_exited", Callable(self, "_on_hover_exited"))

	call_deferred("_apply_ui_when_ready")

func _process(delta: float) -> void:
	if has_meta("target_pos"):
		var target: Vector3 = get_meta("target_pos") as Vector3
		# Instant Y hover, smooth X/Z
		var new_pos := Vector3(
			lerp(position.x, target.x, delta * move_speed),
			target.y,
			lerp(position.z, target.z, delta * move_speed)
		)
		position = new_pos

	if has_meta("target_rot"):
		rotation = rotation.lerp(get_meta("target_rot") as Vector3, delta * rotate_speed)

# ------------------------------------------------------------------------------

func _on_hover_entered() -> void:
	if zone_type == "hand" and zone_owner == "player" and current_zone:
		is_hovered = true
		current_zone.update_hand_hover(self)
		_update_hover_transform()

func _on_hover_exited() -> void:
	if zone_type == "hand" and zone_owner == "player" and current_zone:
		is_hovered = false
		current_zone.update_hand_hover(null)
		_update_hover_transform()

func _update_hover_transform() -> void:
	var base_pos: Vector3 = get_meta("layout_pos") as Vector3 if has_meta("layout_pos") else position
	var base_rot: Vector3 = get_meta("layout_rot") as Vector3 if has_meta("layout_rot") else rotation

	if is_hovered and zone_type == "hand" and zone_owner == "player":
		# Lift card along camera up vector
		var cam: Camera3D = get_viewport().get_camera_3d()
		if cam:
			var up_lift := cam.transform.basis.y.normalized() * (hover_lift + get_card_height() * 3)
			base_pos += up_lift

	set_meta("target_pos", base_pos)
	set_meta("target_rot", base_rot)

# ------------------------------------------------------------------------------

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
	current_zone_key = ""

# ------------------------------------------------------------------------------

func _apply_ui_when_ready() -> void:
	if not sub_viewport:
		await get_tree().process_frame
		sub_viewport = get_node_or_null("SubViewport")
	if not sub_viewport:
		DebugTools.warn("Card.Errors", "SubViewport never ready")
		return

	var card_ui := sub_viewport.get_node_or_null("CardUi")
	var attempts := 0
	while not card_ui and attempts < 10:
		await get_tree().process_frame
		card_ui = sub_viewport.get_node_or_null("CardUi")
		attempts += 1
	if not card_ui:
		DebugTools.warn("Card.Errors", "CardUi never appeared")
		return

	apply_card_data()

func apply_card_data() -> void:
	if not card_data:
		DebugTools.warn("Card.Errors", "No card_data to apply")
		return

	var card_ui := sub_viewport.get_node_or_null("CardUi")
	if not card_ui:
		DebugTools.warn("Card.Errors", "CardUi missing at apply time")
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

	DebugTools.log("Card.UI", "Card UI applied: %s" % card_data.card_name)

# ------------------------------------------------------------------------------

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

# ------------------------------------------------------------------------------

func update_zone_info(zone_node: Node3D) -> void:
	current_zone = zone_node
	zone_type = zone_node.get_meta("zone_type") if zone_node and zone_node.has_meta("zone_type") else ""
	zone_owner = zone_node.get_meta("owner") if zone_node and zone_node.has_meta("owner") else ""

func get_card_height() -> float:
	if has_node("MeshInstance3D"):
		var mesh_instance := get_node("MeshInstance3D")
		if mesh_instance is MeshInstance3D and mesh_instance.mesh:
			return mesh_instance.mesh.get_aabb().size.y
	return default_height
