extends Node

@onready var zone_manager: ZoneManager = $ZoneManager
@onready var player_deck_manager: DeckManager = $PlayerDeckManager

func _ready() -> void:
	print("\n=== Zone Traversal Test Start ===")

	player_deck_manager.load_base_cards()
	player_deck_manager.deck_size = 1
	player_deck_manager.initialize_deck("player")

	# Run the traversal twice
	for turn in range(2):
		print("\n--- Turn %d ---" % (turn + 1))
		_run_cycle()

	print("\n=== Zone Traversal Test End ===")

func _run_cycle() -> void:
	print("\nStart")
	_print_all_zones()

	var card_id := player_deck_manager.draw_card("player")
	print("\nDraw Card")
	_print_all_zones()

	player_deck_manager.move_card("player_hand", "player_play", card_id)
	print("\nPlay Card")
	_print_all_zones()

	player_deck_manager.cleanup_play_zone("player")
	print("\nDiscard Card")
	_print_all_zones()

	player_deck_manager.reshuffle_discard_into_deck("player")
	print("\nReshuffle Card to Deck")
	_print_all_zones()

func _print_all_zones() -> void:
	print("   player_deck:", zone_manager.get_cards_in_zone("player_deck"))
	print("   player_hand:", zone_manager.get_cards_in_zone("player_hand"))
	print("   player_play:", zone_manager.get_cards_in_zone("player_play"))
	print("   player_discard:", zone_manager.get_cards_in_zone("player_discard"))
