extends Node3D
class_name CardGameManager

@export var player_deck_manager_path: NodePath
@export var card_factory_path: NodePath
@export var zone_manager_path: NodePath
@export var camera_path: NodePath
@export var cards_to_draw_per_action: int = 5

var player_deck_manager: DeckManager
var card_factory: CardFactory
var zone_manager: ZoneManager
var camera: Camera3D
var zones: Dictionary = {}

var has_drawn_this_turn: bool = false
var game_started: bool = false


func _ready() -> void:
	add_to_group("CardGameManager")

	player_deck_manager = get_node(player_deck_manager_path)
	card_factory = get_node(card_factory_path)
	zone_manager = get_node(zone_manager_path)
	camera = get_node(camera_path)

	zone_manager.set_camera(camera)

	await get_tree().process_frame
	zones = zone_manager.zones

	if not player_deck_manager.deck_state_changed.is_connected(_on_deck_state_changed):
		player_deck_manager.deck_state_changed.connect(_on_deck_state_changed)

	card_factory.deck_manager = player_deck_manager

	_connect_deck_signals()

	DebugTools.log("CardGameManager.Init", "CardGameManager ready — waiting for UI to start match")


func start_game() -> void:
	if game_started:
		DebugTools.warn("CardGameManager.Errors", "Game already started")
		return

	await get_tree().process_frame
	await get_tree().process_frame

	DebugTools.log("CardGameManager.GameStart", "Starting game — initializing decks")
	game_started = true

	player_deck_manager.initialize_deck("player")
	player_deck_manager.initialize_deck("opponent")

	DebugTools.log("CardGameManager.GameStart", "Decks initialized")


func _connect_deck_signals() -> void:
	for zone_key in zones.keys():
		var zone: Node = zones[zone_key]

		if zone.has_signal("deal_requested"):
			if not zone.deal_requested.is_connected(_on_deal_requested):
				zone.deal_requested.connect(_on_deal_requested)

				DebugTools.log(
					"CardGameManager.Signals",
					"%s → Connected deal_requested" % zone.get_meta("owner")
				)


func _on_deck_state_changed(deck_state: Dictionary, side: String) -> void:
	if not game_started:
		return

	card_factory.update_cards_for_side(deck_state, zones, side)


func _on_deal_requested() -> void:
	if not game_started:
		DebugTools.warn("CardGameManager.Errors", "Cannot deal — game not started")
		return

	if has_drawn_this_turn:
		DebugTools.warn("CardGameManager.Errors", "Player already drew this turn")
		return

	DebugTools.log("CardGameManager.Dealing", "Player requested a draw")
	_deal_card_to_player(cards_to_draw_per_action)
	has_drawn_this_turn = true


func _deal_card_to_player(count: int) -> void:
	DebugTools.log("CardGameManager.Dealing", "Requested %d card(s)" % count)

	var max_available: int = player_deck_manager.deck_state["player_deck"].size()
	var actual_count: int = min(count, max_available)

	for i in range(actual_count):
		var live_deck: Array = player_deck_manager.deck_state["player_deck"]
		if live_deck.is_empty():
			break

		var instance_id: String = live_deck.front()
		player_deck_manager.move_card("player_deck", "player_hand", instance_id)

		DebugTools.log(
			"CardGameManager.Dealing",
			"player → Requested move of instance_id %s from deck → hand" % instance_id
		)

	DebugTools.log(
		"CardGameManager.Dealing",
		"After → Deck: %s" % str(player_deck_manager.deck_state["player_deck"])
	)
