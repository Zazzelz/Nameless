extends Node

func _ready() -> void:
	var deck_manager := DeckManager.new()
	add_child(deck_manager)

	# Connect to signal BEFORE initializing deck
	deck_manager.connect("deck_state_changed", Callable(self, "_on_deck_ready"))

	# Manually trigger deck setup
	deck_manager.load_base_cards()
	deck_manager.initialize_deck("player")
	deck_manager.initialize_deck("opponent")
	deck_manager.save_deck_state("user://decks/test_deck.json")

func _on_deck_ready(_deck_state: Dictionary) -> void:
	
	print("📣 Deck state changed, reading JSON now...")
	_read_deck_json("user://decks/test_deck.json")

func _read_deck_json(path: String) -> void:
	print("🔍 Attempting to read deck JSON from:", path)

	if FileAccess.file_exists(path):
		var deck_path := "user://decks/test_deck.json"
		if not FileAccess.file_exists(deck_path):
			push_error("❌ Deck file not found at: %s" % path)
			return
		print("✅ File exists, reading now...")
		var file := FileAccess.open(path, FileAccess.READ)
		var json_text := file.get_as_text()
		var result: Variant = JSON.parse_string(json_text)
		if result is Dictionary:
			print("📦 Deck contents:")
			for key in result.keys():
				print("  %s: %s" % [key, result[key]])
		else:
			push_error("❌ Failed to parse JSON.")
	else:
		push_error("❌ Deck file not found at: %s" % path)
