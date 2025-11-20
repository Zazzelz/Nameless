extends Node

@onready var deck_manager: DeckManager = $PlayerDeckManager
@onready var zone_manager: ZoneManager = $ZoneManager

func _ready() -> void:
	print("\n=== GameBoardTest Start ===")

	# Load base card definitions
	deck_manager.load_base_cards()

	# Pick a template card
	var template_id = "Disadvantage001"
	var instance_id = "%s_copy_0" % template_id

	# Register lookup so ZoneManager can resolve CardData
	deck_manager.instance_lookup[instance_id] = template_id

	# Seed deck_state with one card in both deck and hand
	deck_manager.deck_state = {
		"player_deck": [instance_id],
		"player_hand": [instance_id],
		"player_play": [],
		"player_discard": [],
		"opponent_deck": [],
		"opponent_hand": [],
		"opponent_play": [],
		"opponent_discard": []
	}

	# Emit signal so ZoneManager spawns visuals
	deck_manager.deck_state_changed.emit(deck_manager.deck_state)

	await get_tree().process_frame
	print("\nSpawned one card in deck and hand:")
	_print_zones()

func _print_zones() -> void:
	print("player_deck:", zone_manager.get_cards_in_zone("player_deck"))
	print("player_hand:", zone_manager.get_cards_in_zone("player_hand"))
