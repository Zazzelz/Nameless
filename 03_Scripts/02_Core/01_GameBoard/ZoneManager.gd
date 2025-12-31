extends Node
class_name ZoneManager

# === Debug Toggle ===
@export var debug_enabled: bool = false

func _log(msg: String) -> void:
	if debug_enabled:
		print(msg)

func _warn(msg: String) -> void:
	if debug_enabled:
		push_warning(msg)

@export var player_deck_manager_path: NodePath = "../PlayerDeckManager"
@export var opponent_deck_manager_path: NodePath = "../OpponentDeckManager"

@onready var player_deck_manager: DeckManager = get_node_or_null(player_deck_manager_path)
@onready var opponent_deck_manager: DeckManager = get_node_or_null(opponent_deck_manager_path)

@export var render_visuals: bool = true

var zones: Dictionary = {}

func _ready() -> void:
	_log("ZoneManager: Initializing...")

	var expected_zone_names := [
		"PlayerDeckZone", "PlayerHandZone", "PlayerPlayZone", "PlayerDiscardZone",
		"OpponentDeckZone", "OpponentHandZone", "OpponentPlayZone", "OpponentDiscardZone"
	]

	for zone_name in expected_zone_names:
		var node := get_tree().get_root().find_child(zone_name, true, false)
		if node and node is Node3D:
			var key: String = _normalize_zone_name(zone_name)
			zones[key] = node
			_log("Zone mapped: %s → %s" % [key, node.name])
		else:
			_warn("ZoneManager: Zone not found or not Node3D: %s" % zone_name)

	_log("Zones discovered: %s" % str(zones.keys()))

	if player_deck_manager:
		_log("PlayerDeckManager found.")
		player_deck_manager.deck_state_changed.connect(_on_deck_state_changed)
	else:
		_warn("ZoneManager: PlayerDeckManager not assigned.")

	if opponent_deck_manager:
		_log("OpponentDeckManager found.")
		opponent_deck_manager.deck_state_changed.connect(_on_deck_state_changed)
	else:
		_warn("ZoneManager: OpponentDeckManager not assigned.")

func _on_deck_state_changed(deck_state: Dictionary) -> void:
	_log("Deck state changed. Zones in state: %s" % str(deck_state.keys()))

	for zone_key in deck_state.keys():
		if zones.has(zone_key):
			var raw_ids: Array = deck_state.get(zone_key, [])
			var instance_ids: Array[String] = []

			for id in raw_ids:
				if typeof(id) == TYPE_STRING:
					instance_ids.append(id)
				else:
					_warn("Non-string ID in zone %s: %s" % [zone_key, id])

			_log("Zone %s contains %d cards" % [zone_key, instance_ids.size()])

			if render_visuals:
				render_zone(zones[zone_key], instance_ids)
		else:
			_warn("ZoneManager: No zone mapped for key: %s" % zone_key)

func render_zone(zone_node: Node3D, instance_ids: Array[String]) -> void:
	if not zone_node:
		_warn("ZoneManager: Zone node is null.")
		return

	for child in zone_node.get_children():
		child.queue_free()

	var deck_manager := get_deck_manager_for_zone(zone_node.name)
	if not deck_manager:
		_warn("ZoneManager: No deck manager found for zone: %s" % zone_node.name)
		return

	for i in range(instance_ids.size()):
		spawn_visual_card(instance_ids[i], zone_node, i, deck_manager)

func spawn_visual_card(instance_id: String, zone_node: Node3D, index: int, deck_manager: DeckManager) -> void:
	var template_id: String = deck_manager.instance_lookup.get(instance_id, "")
	if template_id == "":
		_warn("ZoneManager: No template ID found for instance: %s" % instance_id)
		return

	var card_data: CardData = deck_manager.base_cards.get(template_id, null)
	if card_data == null:
		_warn("ZoneManager: No CardData for template ID %s (instance %s)" % [template_id, instance_id])
		return

	var card_scene: PackedScene = preload("res://02_Scenes/03_Cards/3DCard.tscn")
	var card: Node3D = card_scene.instantiate()

	if card.has_method("setup_from_data"):
		card.setup_from_data(card_data, zone_node, instance_id)

	card.position = Vector3(0, index * 0.002, index * -0.005)

	if zone_node.name.contains("Player"):
		card.rotation_degrees = Vector3(90, 180, 180)
	else:
		card.rotation_degrees = Vector3(90, 0, 0)

	card.scale = Vector3(2, 2, 2)
	card.visible = true

	zone_node.add_child(card)
	_log("Spawned card %s → %s in %s" % [instance_id, template_id, zone_node.name])

func get_deck_manager_for_zone(zone_name: String) -> DeckManager:
	if zone_name.contains("Player"):
		return player_deck_manager
	elif zone_name.contains("Opponent"):
		return opponent_deck_manager
	return null

func _normalize_zone_name(zone_name: String) -> String:
	var base := zone_name.replace("Zone", "")
	var result := ""
	for i in base.length():
		var ch := base[i]
		if i > 0 and ch != ch.to_lower():
			result += "_"
		result += ch.to_lower()
	return result

func get_cards_in_zone(zone_key: String) -> Array[String]:
	var result: Array[String] = []
	if player_deck_manager and player_deck_manager.deck_state.has(zone_key):
		for id in player_deck_manager.deck_state[zone_key]:
			result.append(str(id))
		return result
	if opponent_deck_manager and opponent_deck_manager.deck_state.has(zone_key):
		for id in opponent_deck_manager.deck_state[zone_key]:
			result.append(str(id))
		return result
	return result
