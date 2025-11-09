extends Node
class_name DeckManager

# === Paths ===
const CARD_FOLDER := "res://01_Resources/02_Cards/01_Card_List/"
const DEFAULT_SAVE_PATH := "user://decks/default_deck.json"

# === Signals ===
signal deck_state_changed(deck_state: Dictionary)

# === Data ===
var base_cards: Dictionary = {}  # { "Boost001": CardData, ... }
var instance_lookup: Dictionary = {}  # { "Boost001_copy_3_198273": "Boost001", ... }

var deck_state: Dictionary = {
	"player_deck": [],
	"player_hand": [],
	"player_discard": [],
	"player_play": [],
	"opponent_deck": [],
	"opponent_hand": [],
	"opponent_discard": [],
	"opponent_play": []
}

@export var deck_size: int = 10

# === Lifecycle ===
func _ready() -> void:
	print("🌀 DeckManager ready. Starting setup...")
	randomize()
	load_base_cards()

	if FileAccess.file_exists(DEFAULT_SAVE_PATH):
		print("📂 Found existing deck file. Loading...")
		load_deck_state(DEFAULT_SAVE_PATH)
	else:
		print("🧪 No deck file found. Generating new decks...")
		initialize_deck("player")
		initialize_deck("opponent")
		save_deck_state(DEFAULT_SAVE_PATH)
		print("💾 New deck saved to:", DEFAULT_SAVE_PATH)

	emit_signal("deck_state_changed", deck_state)

# === Card Loading ===
func load_base_cards() -> void:
	print("📦 Loading base cards from:", CARD_FOLDER)
	base_cards.clear()
	var dir := DirAccess.open(CARD_FOLDER)
	if dir == null:
		push_error("❌ Card folder not found: " + CARD_FOLDER)
		return

	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tres"):
			var path := CARD_FOLDER + "/" + file_name
			var card_data := load(path)
			if card_data is CardData:
				if card_data.template_id == "":
					push_warning("⚠️ Card at %s has empty template_id." % path)
				elif base_cards.has(card_data.template_id):
					push_warning("⚠️ Duplicate template_id: %s at %s" % [card_data.template_id, path])
				else:
					base_cards[card_data.template_id] = card_data
					print("✅ Loaded card:", card_data.template_id)
			else:
				push_warning("⚠️ Invalid CardData at: %s" % path)
		file_name = dir.get_next()
	dir.list_dir_end()
	print("📚 Total cards loaded:", base_cards.size())

# === Deck Logic ===
func initialize_deck(deck_owner: String) -> void:
	print("🧩 Initializing deck for:", deck_owner)
	var deck_key := "%s_deck" % deck_owner
	deck_state[deck_key].clear()
	var ids := base_cards.keys()
	var timestamp := str(Time.get_ticks_msec())

	for i in range(deck_size):
		var template_id: String = ids[randi() % ids.size()]
		var instance_id: String = "%s_copy_%d_%s" % [template_id, i, timestamp]
		deck_state[deck_key].append(instance_id)
		instance_lookup[instance_id] = template_id
		print("  ➕ Added card:", instance_id, "(template:", template_id, ")")

	deck_state[deck_key].shuffle()
	print("🔀 Shuffled deck:", deck_state[deck_key])
	emit_signal("deck_state_changed", deck_state)

func draw_card(deck_owner: String) -> String:
	var deck_key := "%s_deck" % deck_owner
	var hand_key := "%s_hand" % deck_owner

	if deck_state[deck_key].is_empty():
		print("♻️ Deck empty. Reshuffling discard into deck...")
		reshuffle_discard_into_deck(deck_owner)

	if deck_state[deck_key].is_empty():
		push_warning("%s deck is still empty after reshuffle." % deck_owner)
		return ""

	var instance_id: String = deck_state[deck_key].pop_front()
	deck_state[hand_key].append(instance_id)
	var template_id: String = instance_lookup.get(instance_id, "unknown")
	print("🃏 Drew card:", instance_id, "(template:", template_id, ")")
	emit_signal("deck_state_changed", deck_state)
	return instance_id

func draw_cards(deck_owner: String, count: int) -> void:
	print("🎴 Drawing %d cards for %s..." % [count, deck_owner])
	for i in range(count):
		draw_card(deck_owner)

func discard_card(deck_owner: String, instance_id: String) -> void:
	var hand_key := "%s_hand" % deck_owner
	var discard_key := "%s_discard" % deck_owner
	deck_state[hand_key].erase(instance_id)
	deck_state[discard_key].append(instance_id)
	print("🗑️ Discarded card:", instance_id)
	emit_signal("deck_state_changed", deck_state)

func reshuffle_discard_into_deck(deck_owner: String) -> void:
	var deck_key := "%s_deck" % deck_owner
	var discard_key := "%s_discard" % deck_owner
	deck_state[deck_key] += deck_state[discard_key]
	deck_state[discard_key].clear()
	deck_state[deck_key].shuffle()
	print("🔁 Reshuffled discard into deck:", deck_state[deck_key])
	emit_signal("deck_state_changed", deck_state)

func cleanup_play_zone(deck_owner: String) -> void:
	var play_key := "%s_play" % deck_owner
	var discard_key := "%s_discard" % deck_owner
	deck_state[discard_key] += deck_state[play_key]
	deck_state[play_key].clear()
	print("🧹 Cleaned up play zone for:", deck_owner)
	emit_signal("deck_state_changed", deck_state)

func move_card(from_zone: String, to_zone: String, instance_id: String) -> void:
	if deck_state.has(from_zone) and deck_state.has(to_zone):
		deck_state[from_zone].erase(instance_id)
		deck_state[to_zone].append(instance_id)
		print("➡️ Moved card %s from %s to %s" % [instance_id, from_zone, to_zone])
		emit_signal("deck_state_changed", deck_state)

func move_card_to_zone(instance_id: String, target_zone_name: String) -> void:
	var deck_owner := "player" if target_zone_name.contains("Player") else "opponent"
	var zones := ["deck", "hand", "play", "discard"]
	for zone in zones:
		var key := "%s_%s" % [deck_owner, zone]
		if deck_state[key].has(instance_id):
			deck_state[key].erase(instance_id)
	var target_key := "%s_%s" % [deck_owner, target_zone_name.to_lower()]
	deck_state[target_key].append(instance_id)
	print("📍 Moved card %s to zone %s" % [instance_id, target_key])
	emit_signal("deck_state_changed", deck_state)

# === Persistence ===
func save_deck_state(path: String) -> void:
	print("💾 Saving deck to:", path)
	var dir_path := path.get_base_dir()
	if not DirAccess.dir_exists_absolute(dir_path):
		print("📁 Creating directory:", dir_path)
		DirAccess.make_dir_recursive_absolute(dir_path)

	var file := FileAccess.open(path, FileAccess.WRITE)
	if file:
		var save_data := {
			"deck_state": deck_state,
			"instance_lookup": instance_lookup
		}
		file.store_string(JSON.stringify(save_data, "\t"))
		file.close()
		print("✅ Deck saved successfully.")
	else:
		push_error("❌ Failed to open file for writing.")

func load_deck_state(path: String) -> void:
	print("📂 Loading deck from:", path)

	if not FileAccess.file_exists(path):
		push_warning("⚠️ Deck file not found at: %s" % path)
		return  # Gracefully exit if file doesn't exist

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("❌ Failed to open deck file.")
		return

	var json := file.get_as_text()
	var result: Variant = JSON.parse_string(json)

	file.close()

	if result is Dictionary:
		if result.has("deck_state") and result.has("instance_lookup"):
			deck_state = result["deck_state"]
			instance_lookup = result["instance_lookup"]
			print("✅ Deck loaded. Zones:")
			for zone in deck_state.keys():
				var zone_cards: Array = deck_state[zone]
				print("  %s: %s" % [zone, zone_cards])
				for instance_id in zone_cards:
					var template_id: String = instance_lookup.get(instance_id, "")
					if template_id == "" or not base_cards.has(template_id):
						push_warning("⚠️ Unknown template ID for instance %s in zone %s" % [instance_id, zone])
		else:
			push_warning("⚠️ JSON file missing expected keys. Using empty deck state.")
			deck_state.clear()
			instance_lookup.clear()
	else:
		push_error("❌ JSON parse failed. Using empty deck state.")
		deck_state.clear()
		instance_lookup.clear()


# === Helpers ===
func get_card_data(instance_id: String) -> CardData:
	var template_id: String = instance_lookup.get(instance_id, "")
	return base_cards.get(template_id, null)
