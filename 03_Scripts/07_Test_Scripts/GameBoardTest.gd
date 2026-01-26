extends Node
class_name GameBoardTest

@onready var deck_manager: DeckManager = $PlayerDeckManager
@onready var zone_manager: ZoneManager = $ZoneManager

func _ready() -> void:
	print("\n=== GameBoardTest Start ===")

	# Load base card definitions
	deck_manager.load_base_cards()

	# Pick a template card
	var template_id := "Disadvantage001"

	# Create one unique instance per zone
	var ids := {
		"player_deck": "%s_pdeck" % template_id,
		"player_hand": "%s_phand" % template_id,
		"player_play": "%s_pplay" % template_id,
		"player_discard": "%s_pdiscard" % template_id,
		"opponent_deck": "%s_odeck" % template_id,
		"opponent_hand": "%s_ohand" % template_id,
		"opponent_play": "%s_oplay" % template_id,
		"opponent_discard": "%s_odiscard" % template_id
	}

	# Register all instance IDs
	for key in ids.keys():
		deck_manager.instance_lookup[ids[key]] = template_id

	# Seed deck_state with one card in every zone
	deck_manager.deck_state = {
		"player_deck": [ids["player_deck"]],
		"player_hand": [ids["player_hand"]],
		"player_play": [ids["player_play"]],
		"player_discard": [ids["player_discard"]],
		"opponent_deck": [ids["opponent_deck"]],
		"opponent_hand": [ids["opponent_hand"]],
		"opponent_play": [ids["opponent_play"]],
		"opponent_discard": [ids["opponent_discard"]]
	}

	# Emit signal so ZoneManager spawns visuals
	deck_manager.deck_state_changed.emit(deck_manager.deck_state)

	await get_tree().process_frame
	print("\nSpawned one card in ALL zones:")
	_print_zones()

func _print_zones() -> void:
	var keys := [
		"player_deck", "player_hand", "player_play", "player_discard",
		"opponent_deck", "opponent_hand", "opponent_play", "opponent_discard"
	]

	for key in keys:
		print("%s: %s" % [key, zone_manager.get_cards_in_zone(key)])
