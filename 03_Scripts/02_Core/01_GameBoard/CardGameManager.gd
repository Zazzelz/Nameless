extends Node3D
class_name CardGameManager

# === Debug Toggle ===
@export var debug_enabled: bool = false

func _log(msg: String) -> void:
	if debug_enabled:
		print(msg)

func _warn(msg: String) -> void:
	if debug_enabled:
		push_warning(msg)

# === Managers & Factories ===
@onready var player_deck_manager: DeckManager = find_child("PlayerDeckManager", true, false)
@onready var opponent_deck_manager: DeckManager = find_child("OpponentDeckManager", true, false)
@onready var card_factory: CardFactory = find_child("CardFactory", true, false)
@onready var zone_manager: ZoneManager = find_child("ZoneManager", true, false)

# === Zones ===
@onready var zones: Dictionary = {
	"player": {
		"deck": find_child("PlayerDeckZone", true, false) as Node3D,
		"hand": find_child("PlayerHandZone", true, false) as Node3D,
		"play": find_child("PlayerPlayZone", true, false) as Node3D,
		"discard": find_child("PlayerDiscardZone", true, false) as Node3D
	},
	"opponent": {
		"deck": find_child("OpponentDeckZone", true, false) as Node3D,
		"hand": find_child("OpponentHandZone", true, false) as Node3D,
		"play": find_child("OpponentPlayZone", true, false) as Node3D,
		"discard": find_child("OpponentDiscardZone", true, false) as Node3D
	}
}

func _ready() -> void:
	_log("CardGameManager is ready")

	GameContext.board = self
	GameContext.player_play_zone = zones["player"]["play"]
	GameContext.opponent_play_zone = zones["opponent"]["play"]

	card_factory.card_clicked.connect(_on_card_clicked)
	card_factory.card_dropped.connect(_on_card_dropped)

	_setup_game()

# === Game Setup ===
func _setup_game() -> void:
	_log("Setting up game…")

	player_deck_manager.initialize_deck("player")
	opponent_deck_manager.initialize_deck("opponent")

	add_to_group("CardGameManager")

# === Interaction ===
func _on_card_clicked(card: Card) -> void:
	if not card.current_zone:
		return

	var owner: String = card.zone_owner
	var deck_zone: Node3D = zones[owner]["deck"]

	if card.current_zone == deck_zone:
		_log("Card clicked in deck: drawing 5 for %s" % owner)
		_draw_cards(owner, 5)

func _draw_cards(owner: String, count: int) -> void:
	var deck_manager: DeckManager = player_deck_manager if owner == "player" else opponent_deck_manager
	_log("Drawing %d cards for %s" % [count, owner])
	deck_manager.draw_cards(owner, count)

func _on_card_dropped(card: Node3D, target_zone: Node3D) -> void:
	var resolved_card: Card = card if card is Card else _resolve_card_from_node(card)

	if resolved_card:
		var deck_manager: DeckManager = (
			player_deck_manager if resolved_card.zone_owner == "player"
			else opponent_deck_manager
		)

		_log("Card dropped: %s → %s" % [resolved_card.instance_id, target_zone.name])
		deck_manager.move_card_to_zone(resolved_card.card_id, target_zone.name)
	else:
		_warn("Dropped node is not a Card: %s" % card.name)

func _resolve_card_from_node(node: Node) -> Card:
	var current: Node = node
	while current and not (current is Card) and current.get_parent():
		current = current.get_parent()
	return current if current is Card else null

# === Cleanup & Reshuffle ===
func cleanup_play_zones() -> void:
	for owner in ["player", "opponent"]:
		var deck_manager: DeckManager = (
			player_deck_manager if owner == "player"
			else opponent_deck_manager
		)
		_log("Cleaning play zone for %s" % owner)
		deck_manager.cleanup_play_zone(owner)

func check_and_reshuffle_deck(owner: String) -> void:
	var deck_manager: DeckManager = (
		player_deck_manager if owner == "player"
		else opponent_deck_manager
	)
	_log("Reshuffling discard into deck for %s" % owner)
	deck_manager.reshuffle_discard_into_deck(owner)
