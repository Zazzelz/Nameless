extends Node
class_name ZoneTraversalTest

@onready var player_manager: DeckManager = $PlayerDeckManager

# Only player zones
var zones: Array[String] = [
	"player_deck",
	"player_hand",
	"player_play",
    "player_discard"
]

var total_tests: int = 0
var passed_tests: int = 0
var failed_tests: int = 0

func _ready() -> void:
	print("\n=== Player‑Only Zone Traversal Test ===")

	player_manager.load_base_cards()
	player_manager.deck_size = 1
	player_manager.initialize_deck("player")

	var card_id: String = player_manager.draw_card("player")
	if card_id == "":
		push_error("Traversal test failed: could not draw card")
		return

	print("\nTesting card:", card_id)

	_run_full_matrix(card_id)
	_print_summary()

	print("\n=== Traversal Test Complete ===")

# Full traversal matrix for a single card
func _run_full_matrix(instance_id: String) -> void:
	for from_zone in zones:
		for to_zone in zones:
			if from_zone == to_zone:
				continue

			total_tests += 1

			_force_move(instance_id, from_zone)
			player_manager.move_card(from_zone, to_zone, instance_id)
			_validate_transition(from_zone, to_zone, instance_id)

# Force card into a specific zone
func _force_move(instance_id: String, target_zone: String) -> void:
	# Remove from all player zones
	for z in zones:
		if instance_id in player_manager.deck_state[z]:
			player_manager.deck_state[z].erase(instance_id)

	# Add to target zone
	player_manager.deck_state[target_zone].append(instance_id)

# Validate transition (quiet mode)
func _validate_transition(from_zone: String, to_zone: String, instance_id: String) -> void:
	var raw_to: Array = player_manager.deck_state[to_zone]
	var raw_from: Array = player_manager.deck_state[from_zone]

	var to_list: Array[String] = []
	var from_list: Array[String] = []

	for v in raw_to:
		to_list.append(v as String)
	for v in raw_from:
		from_list.append(v as String)

	var in_to: bool = instance_id in to_list
	var in_from: bool = instance_id in from_list

	if in_to and not in_from:
		passed_tests += 1
	else:
		failed_tests += 1
		push_error("FAIL %s → %s" % [from_zone, to_zone])
		_print_all_zones()

# Debug print
func _print_all_zones() -> void:
	print("   player_deck:", player_manager.deck_state["player_deck"])
	print("   player_hand:", player_manager.deck_state["player_hand"])
	print("   player_play:", player_manager.deck_state["player_play"])
	print("   player_discard:", player_manager.deck_state["player_discard"])

# Final summary
func _print_summary() -> void:
	print("\n=== Traversal Summary ===")
	print("Total tests:", total_tests)
	print("Passed:", passed_tests)
	print("Failed:", failed_tests)

	if failed_tests == 0:
		print("\nALL TESTS PASSED 🎉")
	else:
		print("\nSome tests failed. See above for details.")
