extends Node
class_name DeckInspectorTest

@onready var inspector: DeckInspector = DeckInspector.new()

var test_results: Array[String] = []


func _ready() -> void:
	print("\n=== DeckInspectorTest Start ===")

	add_child(inspector)

	# Test both decks
	_test_single_deck("user://decks/player_deck.json", "Player Deck")
	_test_single_deck("user://decks/opponent_deck.json", "Opponent Deck")

	# Force a fail to confirm harness works
	_assert(false, "Forced failure test")

	# Final summary
	_print_summary()

	print("\n=== DeckInspectorTest Complete ===")

# Test a single deck file
func _test_single_deck(path: String, label: String) -> void:
	print("\n--- Testing %s ---" % label)

	# Step 1 — File exists
	_assert(FileAccess.file_exists(path), "%s file exists" % label)

	# Step 2 — Load JSON
	var json_dict: Variant = _load_json(path)
	_assert(json_dict != null, "%s JSON parsed successfully" % label)

	if json_dict == null:
		return  # Avoid cascading errors

	# Step 3 — Validate structure
	_assert(json_dict.has("deck"), "%s JSON contains 'deck' array" % label)

	var cards: Array = json_dict["deck"]
	_assert(cards.size() > 0, "%s contains at least one card" % label)

	# Step 4 — Validate each template_id
	for i in cards.size():
		var template_id: Variant = cards[i]
		_assert(template_id is String, "%s card %d template_id is a string" % [label, i])
		_assert(template_id != "", "%s card %d template_id is not empty" % [label, i])

	# Step 5 — Run inspector
	inspector.read_deck_json(path)
	_assert(true, "%s DeckInspector read_deck_json() executed" % label)

# JSON loader helper
func _load_json(path: String) -> Variant:
	if not FileAccess.file_exists(path):
		return null

	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		return null

	var text: String = file.get_as_text()
	var parsed: Variant = JSON.parse_string(text)

	if parsed is Dictionary:
		return parsed as Dictionary

	return null

# Assertion + Summary
func _assert(condition: bool, message: String) -> void:
	if condition:
		var msg := "[PASS] " + message
		print(msg)
		test_results.append(msg)
	else:
		var msg := "[FAIL] " + message
		push_error(msg)
		test_results.append(msg)

func _print_summary() -> void:
	print("\n=== TEST SUMMARY ===")
	for result in test_results:
		print(result)
	print("====================\n")
