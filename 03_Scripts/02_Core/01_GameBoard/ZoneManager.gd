extends Node
class_name ZoneManager

@export var player_deck_manager_path: NodePath = "../PlayerDeckManager"
@export var opponent_deck_manager_path: NodePath = "../OpponentDeckManager"

@onready var player_deck_manager: DeckManager = get_node_or_null(player_deck_manager_path)
@onready var opponent_deck_manager: DeckManager = get_node_or_null(opponent_deck_manager_path)

@onready var zones: Dictionary = {}

func _ready() -> void:
	print("🧩 ZoneManager: Initializing...")

	var expected_zone_names := [
		"PlayerDeckZone", "PlayerHandZone", "PlayerPlayZone", "PlayerDiscardZone",
		"OpponentDeckZone", "OpponentHandZone", "OpponentPlayZone", "OpponentDiscardZone"
	]

	for zone_name in expected_zone_names:
		var node := get_tree().get_root().find_child(zone_name, true, false)
		if node and node is Node3D:
			var key: String = _normalize_zone_name(zone_name)
			zones[key] = node
			print("✅ Zone mapped:", key, "→", node.name)
		else:
			push_warning("⚠️ ZoneManager: Zone not found or not Node3D: %s" % zone_name)

	print("📦 Zones discovered:", zones.keys())

	if player_deck_manager:
		print("✅ PlayerDeckManager found.")
		player_deck_manager.deck_state_changed.connect(_on_deck_state_changed)
	else:
		push_warning("⚠️ ZoneManager: PlayerDeckManager not assigned.")

	if opponent_deck_manager:
		print("✅ OpponentDeckManager found.")
		opponent_deck_manager.deck_state_changed.connect(_on_deck_state_changed)
	else:
		push_warning("⚠️ ZoneManager: OpponentDeckManager not assigned.")

func _on_deck_state_changed(deck_state: Dictionary) -> void:
	print("🔄 Deck state changed. Zones in state:", deck_state.keys())

	for zone_key in deck_state.keys():
		if zones.has(zone_key):
			var raw_ids: Array = deck_state.get(zone_key, [])
			var instance_ids: Array[String] = []

			for id in raw_ids:
				if typeof(id) == TYPE_STRING:
					instance_ids.append(id)
				else:
					push_warning("⚠️ Non-string ID in zone %s: %s" % [zone_key, id])

			print("🎯 Rendering zone:", zone_key, "with", instance_ids.size(), "cards")
			render_zone(zones[zone_key], instance_ids)
		else:
			push_warning("❌ ZoneManager: No zone mapped for key: %s" % zone_key)

func render_zone(zone_node: Node3D, instance_ids: Array[String]) -> void:
	if not zone_node:
		push_warning("❌ ZoneManager: Zone node is null.")
		return

	print("🧹 Clearing zone:", zone_node.name)
	for child in zone_node.get_children():
		child.queue_free()

	var deck_manager := get_deck_manager_for_zone(zone_node.name)
	if not deck_manager:
		push_warning("❌ ZoneManager: No deck manager found for zone: %s" % zone_node.name)
		return

	for i in range(instance_ids.size()):
		spawn_visual_card(instance_ids[i], zone_node, i, deck_manager)

func spawn_visual_card(instance_id: String, zone_node: Node3D, index: int, deck_manager: DeckManager) -> void:
	var template_id: String = deck_manager.instance_lookup.get(instance_id, "")
	if template_id == "":
		push_warning("❌ ZoneManager: No template ID found for instance: %s" % instance_id)
		return

	var card_data: CardData = deck_manager.base_cards.get(template_id, null)
	if card_data == null:
		push_warning("❌ ZoneManager: No CardData found for template ID: %s (from instance: %s)" % [template_id, instance_id])
		return

	var card_scene: PackedScene = preload("res://02_Scenes/03_Cards/3DCard.tscn")
	var card: Node3D = card_scene.instantiate()

	card.setup_from_data(card_data, zone_node, instance_id)

	card.position = Vector3(0, index * 0.002, index * -0.005)
	card.rotation_degrees = Vector3(90, 180, 180) if zone_node.name.contains("Player") else Vector3(90, 0, 0)
	card.scale = Vector3(2, 2, 2)
	card.visible = true

	zone_node.add_child(card)
	print("🃏 Spawned card:", instance_id, "→", template_id, "in", zone_node.name)

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
