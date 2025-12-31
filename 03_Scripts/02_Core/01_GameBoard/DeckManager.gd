extends Node
class_name DeckManager

signal deck_state_changed(deck_state: Dictionary)

# === Debug Toggle ===
@export var debug_enabled: bool = false

func _log(msg: String) -> void:
	if debug_enabled:
		print(msg)

func _warn(msg: String) -> void:
	if debug_enabled:
		push_warning(msg)

# === Deck State ===
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

# === Template Registry ===
var base_cards: Dictionary = {}          # template_id → CardData
var instance_lookup: Dictionary = {}     # instance_id → template_id

var deck_size: int = 15

#   LOAD CARD TEMPLATES (.tres)
func load_base_cards() -> void:
	base_cards.clear()

	var dir := DirAccess.open("res://01_Resources/02_Cards/01_Card_List/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()

		while file_name != "":
			if file_name.ends_with(".tres"):
				var path = "res://01_Resources/02_Cards/01_Card_List/" + file_name
				var data: CardData = load(path)

				if data and data.template_id != "":
					base_cards[data.template_id] = data
				else:
					_warn("DeckManager: CardData missing template_id at %s" % path)

			file_name = dir.get_next()

	_log("DeckManager: Loaded templates: %s" % str(base_cards.keys()))

#   RANDOM DECK GENERATION
func initialize_deck(side: String) -> void:
	var deck_key = "%s_deck" % side
	deck_state[deck_key] = []

	var template_ids: Array = base_cards.keys()
	if template_ids.is_empty():
		_warn("DeckManager: No templates loaded; cannot initialize deck")
		return

	# Generate random deck
	for i in deck_size:
		var template_id = template_ids.pick_random()
		var instance_id = "%s_%d" % [template_id, randi()]

		instance_lookup[instance_id] = template_id
		deck_state[deck_key].append(instance_id)

	# Reset other zones
	deck_state["%s_hand" % side] = []
	deck_state["%s_play" % side] = []
	deck_state["%s_discard" % side] = []

	deck_state_changed.emit(deck_state)
	_log("DeckManager: Initialized %s deck → %s" % [side, deck_state[deck_key]])

#   DRAW / MOVE / CLEANUP
func draw_card(side: String) -> String:
	var deck_key = "%s_deck" % side
	var hand_key = "%s_hand" % side

	if deck_state[deck_key].is_empty():
		return ""

	var instance_id: String = deck_state[deck_key].pop_front()
	deck_state[hand_key].append(instance_id)

	deck_state_changed.emit(deck_state)
	return instance_id

func move_card(from_zone: String, to_zone: String, instance_id: String) -> void:
	if deck_state.has(from_zone) and deck_state.has(to_zone):
		if instance_id in deck_state[from_zone]:
			deck_state[from_zone].erase(instance_id)
			deck_state[to_zone].append(instance_id)
			deck_state_changed.emit(deck_state)

func cleanup_play_zone(side: String) -> void:
	var play_key = "%s_play" % side
	var discard_key = "%s_discard" % side

	for instance_id in deck_state[play_key]:
		deck_state[discard_key].append(instance_id)

	deck_state[play_key].clear()
	deck_state_changed.emit(deck_state)

func reshuffle_discard_into_deck(side: String) -> void:
	var deck_key = "%s_deck" % side
	var discard_key = "%s_discard" % side

	for instance_id in deck_state[discard_key]:
		deck_state[deck_key].append(instance_id)

	deck_state[discard_key].clear()
	deck_state[deck_key].shuffle()

	deck_state_changed.emit(deck_state)

#   SAVE DECK (TEMPLATE IDS ONLY)
func save_deck_to_json(side: String, path: String) -> void:
	var deck_key = "%s_deck" % side
	var template_ids: Array = []

	for instance_id in deck_state[deck_key]:
		var template_id = instance_lookup.get(instance_id, "")
		if template_id != "":
			template_ids.append(template_id)

	var data := {
		"deck": template_ids
	}

	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "\t"))
		file.close()
		_log("DeckManager: Saved %s deck → %s" % [side, path])
	else:
		_warn("DeckManager: Could not save deck to %s" % path)

#   LOAD DECK (REGENERATE INSTANCE IDS)
func load_deck_from_json(side: String, path: String) -> void:
	if not FileAccess.file_exists(path):
		_warn("DeckManager: No deck file at %s" % path)
		return

	var file = FileAccess.open(path, FileAccess.READ)
	var result = JSON.parse_string(file.get_as_text())
	file.close()

	if typeof(result) != TYPE_DICTIONARY:
		_warn("DeckManager: Invalid JSON deck file")
		return

	var template_ids: Array = result.get("deck", [])
	var deck_key = "%s_deck" % side

	deck_state[deck_key] = []
	instance_lookup.clear()

	for template_id in template_ids:
		if base_cards.has(template_id):
			var instance_id = "%s_%d" % [template_id, randi()]
			instance_lookup[instance_id] = template_id
			deck_state
