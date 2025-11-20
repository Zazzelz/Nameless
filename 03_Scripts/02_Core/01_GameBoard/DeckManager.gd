extends Node
class_name DeckManager

signal deck_state_changed(deck_state: Dictionary)

var deck_state: Dictionary = {
	"player_deck": [],
	"player_hand": [],
	"player_play": [],
	"player_discard": [],
	"opponent_deck": [],
	"opponent_hand": [],
	"opponent_play": [],
	"opponent_discard": []
}

var base_cards: Dictionary = {}
var instance_lookup: Dictionary = {}
var deck_size: int = 5

func load_base_cards() -> void:
	# Stub card data
	var card_id = "Disadvantage001"
	base_cards[card_id] = CardData.new() # Replace with your actual card data
	print("DeckManager: Base cards loaded:", base_cards.keys())

func initialize_deck(player: String) -> void:
	var deck_key = "%s_deck" % player
	deck_state[deck_key] = []  # ensure the array exists

	var instance_id = "%s_copy_%d_%d" % ["Disadvantage001", 0, randi() % 9999]
	instance_lookup[instance_id] = "Disadvantage001"
	deck_state[deck_key].append(instance_id)

	print("DEBUG: deck_state seeded:", deck_state)
	deck_state_changed.emit(deck_state)

func draw_card(player: String) -> String:
	var deck_key = "%s_deck" % player
	var hand_key = "%s_hand" % player

	if deck_state[deck_key].is_empty():
		return ""
	var card_id: String = deck_state[deck_key].pop_front()
	deck_state[hand_key].append(card_id)
	deck_state_changed.emit(deck_state)
	return card_id

func move_card(from_zone: String, to_zone: String, card_id: String) -> void:
	if deck_state.has(from_zone) and deck_state.has(to_zone):
		if card_id in deck_state[from_zone]:
			deck_state[from_zone].erase(card_id)
			deck_state[to_zone].append(card_id)
			deck_state_changed.emit(deck_state)

func cleanup_play_zone(player: String) -> void:
	var play_key = "%s_play" % player
	var discard_key = "%s_discard" % player

	for card_id in deck_state[play_key]:
		deck_state[discard_key].append(card_id)
	deck_state[play_key].clear()
	deck_state_changed.emit(deck_state)

func reshuffle_discard_into_deck(player: String) -> void:
	var deck_key = "%s_deck" % player
	var discard_key = "%s_discard" % player

	for card_id in deck_state[discard_key]:
		deck_state[deck_key].append(card_id)
	deck_state[discard_key].clear()
	deck_state[deck_key].shuffle()
	deck_state_changed.emit(deck_state)
	
# DeckManager.gd

func save_deck_to_json(side: String, path: String) -> void:
	# side should be "player" or "opponent"
	var side_keys = []
	for key in deck_state.keys():
		if key.begins_with(side + "_"):
			side_keys.append(key)

	var side_state: Dictionary = {}
	for key in side_keys:
		side_state[key] = deck_state[key]

	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(side_state, "\t") # pretty print
		file.store_string(json_string)
		file.close()
		print("DeckManager: Saved %s deck to %s" % [side, path])
	else:
		push_warning("DeckManager: Could not open file for saving: %s" % path)


func load_deck_from_json(side: String, path: String) -> void:
	if not FileAccess.file_exists(path):
		push_warning("DeckManager: No deck file at %s" % path)
		return

	var file = FileAccess.open(path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()

	var result = JSON.parse_string(content)
	if typeof(result) == TYPE_DICTIONARY:
		for key in result.keys():
			deck_state[key] = result[key]
		deck_state_changed.emit(deck_state)
		print("DeckManager: Loaded %s deck from %s" % [side, path])
	else:
		push_warning("DeckManager: Failed to parse JSON deck file: %s" % path)

func get_deck_data(side: String) -> Array[CardData]:
	var ids: Array = deck_state.get("%s_deck" % side, [])
	var out: Array[CardData] = []
	for instance_id in ids:
		var template_id: String = instance_lookup.get(instance_id, "")
		if template_id == "":
			push_warning("DeckManager: No template for instance_id: %s" % instance_id)
			continue
		var data: CardData = base_cards.get(template_id, null)
		if data == null:
			push_warning("DeckManager: No CardData for template_id: %s" % template_id)
			continue
		out.append(data)
	return out
