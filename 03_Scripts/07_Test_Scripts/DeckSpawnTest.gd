extends Node3D

@onready var factory: CardFactory = $CardFactory
var deck_manager: DeckManager

@export var test_deck_size: int = 5

var test_results: Array[String] = []


func _ready() -> void:
	print("\n=== DeckTest Start ===")

	# Create DeckManager
	deck_manager = DeckManager.new()
	add_child(deck_manager)
	_assert(deck_manager != null, "DeckManager created")

	# Override deck size for testing
	deck_manager.deck_size = test_deck_size
	_assert(deck_manager.deck_size == test_deck_size, "Deck size overridden correctly")

	# Ensure directory exists
	var dir := DirAccess.open("user://")
	if not dir.dir_exists("decks"):
		dir.make_dir("decks")
	_assert(DirAccess.open("user://").dir_exists("decks"), "Deck directory exists")

	# Load templates
	deck_manager.load_base_cards()
	_assert(deck_manager.base_cards.size() > 0, "Card templates loaded")

	# Initialize decks
	deck_manager.initialize_deck("player")
	deck_manager.initialize_deck("opponent")

	_assert(deck_manager.deck_state["player_deck"].size() == test_deck_size,
		"Player deck initialized to correct size")
	_assert(deck_manager.deck_state["opponent_deck"].size() == test_deck_size,
		"Opponent deck initialized to correct size")

	# Save decks
	deck_manager.save_deck_to_json("player", "user://decks/player_deck.json")
	deck_manager.save_deck_to_json("opponent", "user://decks/opponent_deck.json")

	_assert(FileAccess.file_exists("user://decks/player_deck.json"),
		"Player deck JSON saved")
	_assert(FileAccess.file_exists("user://decks/opponent_deck.json"),
		"Opponent deck JSON saved")

	print("Player deck saved at:", ProjectSettings.globalize_path("user://decks/player_deck.json"))
	print("Opponent deck saved at:", ProjectSettings.globalize_path("user://decks/opponent_deck.json"))

	# Spawn piles visually
	var player_spawned := _spawn_deck_pile("player", Vector3(0, 0, 0))
	var opponent_spawned := _spawn_deck_pile("opponent", Vector3(2, 0, 0))

	_assert(player_spawned, "Player cards spawned successfully")
	_assert(opponent_spawned, "Opponent cards spawned successfully")

	# Final summary
	_print_summary()

	print("\n=== DeckTest Complete ===")


# === Visual helpers ===
func _spawn_deck_pile(deck_owner: String, pile_position: Vector3) -> bool:
	var deck_data: Array[CardData] = deck_manager.get_deck_data(deck_owner)
	if deck_data.is_empty():
		return false

	var offset := Vector3(0, 0.05, 0)

	for i in range(min(deck_data.size(), 10)):
		var card_data: CardData = deck_data[i]
		if card_data == null:
			return false

		var card_node := factory.create_card(card_data, deck_owner)
		if card_node == null:
			return false

		add_child(card_node)
		card_node.position = pile_position + offset * i
		card_node.rotation_degrees = Vector3(-90, 0, 0)

	return true


# === Assertion + Summary ===
func _assert(condition: bool, message: String) -> void:
	if condition:
		var msg = "[PASS] " + message
		print(msg)
		test_results.append(msg)
	else:
		var msg = "[FAIL] " + message
		push_error(msg)
		test_results.append(msg)


func _print_summary() -> void:
	print("\n=== TEST SUMMARY ===")
	for result in test_results:
		print(result)
	print("====================\n")
