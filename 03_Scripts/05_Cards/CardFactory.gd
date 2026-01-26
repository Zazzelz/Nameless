extends Node
class_name CardFactory

const CARD_SCENE: PackedScene = preload("res://02_Scenes/03_Cards/3DCard.tscn")

var card_index: int = 0
var deck_manager: DeckManager

signal card_clicked(card: Card)
signal card_dropped(card: Card, target_zone: Node3D)


func create_card(
	card_data: CardData,
	owner: String,
	zone_node: Node3D,
	instance_id: String,
	reuse_card: Card = null
) -> Card:

	if not card_data:
		DebugTools.warn("CardFactory.Errors", "%s → Received null CardData" % owner)
		return null

	var card: Card = reuse_card if reuse_card else CARD_SCENE.instantiate()
	card.name = "Card_%d" % card_index
	card_index += 1

	card.setup_from_data(card_data, zone_node, instance_id)
	card.zone_owner = owner
	card.add_to_group("%s_cards" % owner)

	_connect_card_signals(card)

	# Add card to zone
	zone_node.add_child(card)

	return card


func _connect_card_signals(card: Card) -> void:
	if not card.is_connected("card_clicked", Callable(self, "_on_card_clicked")):
		card.connect("card_clicked", Callable(self, "_on_card_clicked"))

	if not card.is_connected("card_dropped", Callable(self, "_on_card_dropped")):
		card.connect("card_dropped", Callable(self, "_on_card_dropped"))


func _on_card_clicked(card: Card) -> void:
	card_clicked.emit(card)


func _on_card_dropped(card: Card, target_zone: Node3D) -> void:
	card_dropped.emit(card, target_zone)


func update_cards_for_side(deck_state: Dictionary, zones: Dictionary, side: String) -> void:
	for zone_key in deck_state.keys():

		if not zone_key.begins_with("%s_" % side):
			continue

		var zone_node: Node3D = zones.get(zone_key)
		if zone_node == null:
			continue

		var owner: String = zone_node.get_meta("owner")
		var desired_ids: Array = deck_state[zone_key]
		var existing_cards: Dictionary = {}

		for child in zone_node.get_children():
			if child is Card:
				existing_cards[child.instance_id] = child

		# Update metadata for existing cards
		for instance_id in desired_ids:
			if existing_cards.has(instance_id):
				var card: Card = existing_cards[instance_id]
				card.current_zone_key = zone_key
				card.update_zone_info(zone_node)

		# Spawn missing cards
		for instance_id in desired_ids:
			if not existing_cards.has(instance_id):

				if not deck_manager.instance_lookup.has(instance_id):
					DebugTools.warn("CardFactory.Errors", "Missing instance_id %s" % instance_id)
					continue

				var template_id: String = deck_manager.instance_lookup[instance_id]

				if not deck_manager.base_cards.has(template_id):
					DebugTools.warn("CardFactory.Errors", "Missing template_id %s" % template_id)
					continue

				var card_data: CardData = deck_manager.base_cards[template_id]
				var card: Card = create_card(card_data, owner, zone_node, instance_id)

				card.current_zone_key = zone_key
				card.update_zone_info(zone_node)

		# Remove cards that shouldn't be here
		for existing_id in existing_cards.keys():
			if not desired_ids.has(existing_id):
				existing_cards[existing_id].queue_free()

		# --- Layout and apply transforms ---
		if zone_node.has_method("layout_hand"):
			zone_node.layout_hand()
		elif zone_node.has_method("layout_cards"):
			zone_node.layout_cards()
		elif zone_node.has_method("layout_play"):
			zone_node.layout_play()
		elif zone_node.has_method("layout_discard"):
			zone_node.layout_discard()
