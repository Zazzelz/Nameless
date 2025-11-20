extends Node3D

@onready var factory: CardFactory = $CardFactory
var deck_manager: DeckManager

func _ready() -> void:
	print("\n=== DeckTest Start ===")

	# Create and add DeckManager
	deck_manager = DeckManager.new()
	add_child(deck_manager)

	# Connect to signal BEFORE initializing deck
	deck_manager.connect("deck_state_changed", Callable(self, "_on_deck_ready"))

	# Ensure directory exists before saving
	var dir := DirAccess.open("user://")
	if not dir.dir_exists("decks"):
		dir.make_dir("decks")

	# --- Initialize decks ---
	deck_manager.load_base_cards()
	deck_manager.initialize_deck("player")
	deck_manager.initialize_deck("opponent")

	# --- Save decks separately ---
	deck_manager.save_deck_to_json("player", "user://decks/player_deck.json")
	deck_manager.save_deck_to_json("opponent", "user://decks/opponent_deck.json")

	print("Player deck saved at:", ProjectSettings.globalize_path("user://decks/player_deck.json"))
	print("Opponent deck saved at:", ProjectSettings.globalize_path("user://decks/opponent_deck.json"))

	# --- Spawn piles visually ---
	_spawn_deck_pile("player", Vector3(0, 0, 0))
	_spawn_deck_pile("opponent", Vector3(2, 0, 0)) # offset so you can see both piles

# === Visual helpers ===
func _spawn_deck_pile(deck_owner: String, pile_position: Vector3) -> void:
	var deck_data: Array[CardData] = deck_manager.get_deck_data(deck_owner)
	var offset := Vector3(0, 0.05, 0)  # spacing between cards

	for i in range(min(deck_data.size(), 10)): # spawn first 10 cards for demo
		var card_data: CardData = deck_data[i]
		var card_node := factory.create_card(card_data, deck_owner)
		add_child(card_node)

		# Position stacked
		card_node.position = pile_position + offset * i

		# Rotate flat on the ground
		card_node.rotation_degrees = Vector3(-90, 0, 0)

# === Signal callbacks ===
func _on_deck_ready(_deck_state: Dictionary) -> void:
	print("Deck state changed, reading JSON now...")
	_read_deck_json("user://decks/player_deck.json")
	_read_deck_json("user://decks/opponent_deck.json")

func _read_deck_json(path: String) -> void:
	print("Attempting to read deck JSON from:", path)

	if not FileAccess.file_exists(path):
		push_error("Deck file not found at: %s" % path)
		return

	var file := FileAccess.open(path, FileAccess.READ)
	var json_text := file.get_as_text()
	var result: Variant = JSON.parse_string(json_text)

	if result is Dictionary:
		print("Deck contents from %s:" % path)
		for key in result.keys():
			print("  %s: %s" % [key, result[key]])
	else:
		push_error("Failed to parse JSON.")
