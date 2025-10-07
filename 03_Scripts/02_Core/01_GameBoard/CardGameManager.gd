extends Node3D
class_name CardGameManager

@onready var player_deck_manager := find_child("PlayerDeckManager", true, false) as DeckManager
@onready var opponent_deck_manager := find_child("OpponentDeckManager", true, false) as DeckManager

@onready var card_factory := find_child("CardFactory", true, false) as Node
@onready var zone_manager := find_child("ZoneManager", true, false) as Node

@onready var player_deck_zone: Node3D = find_child("PlayerDeckZone", true, false)
@onready var opponent_deck_zone: Node3D = find_child("OpponentDeckZone", true, false)

@onready var player_hand_zone: Node3D = find_child("PlayerHandZone", true, false)
@onready var opponent_hand_zone: Node3D = find_child("OpponentHandZone", true, false)

@onready var card_game_manager := self


var card_index := 0

func _ready():
	print("CardGameBoard is ready")
	print("Active camera:", get_viewport().get_camera_3d())

	call_deferred("_setup_game")
	
	if not player_deck_manager or not opponent_deck_manager:
		push_error("Deck managers not found — check scene structure or script attachment")
	if not player_deck_zone or not opponent_deck_zone:
		push_error("Deck zones not found — check scene structure")

func _setup_game():
	if not card_factory or not card_game_manager:
		push_error("Factory or Manager missing — cannot wire signals")
		return

	card_factory.card_clicked_from_factory.connect(Callable(card_game_manager, "_on_card_clicked"))
	print("Signal connected from CardFactory to CardGameManager")

	for i in range(4):
		deal_card_to_player_deck()
		deal_card_to_opponent_deck()

func deal_card_to_player_deck():
	var card_data = player_deck_manager.draw_card()
	if card_data:
		draw_and_place_card(opponent_deck_manager, "player_cards", player_deck_zone)
		print("Card sent to player deck")

func deal_card_to_opponent_deck():
	var card_data = opponent_deck_manager.draw_card()
	if card_data:
		draw_and_place_card(opponent_deck_manager, "opponent_cards", opponent_deck_zone)

func spawn_card(card: Node3D, target_zone: Node3D, index: int):
	if target_zone.has_method("spawn_card"):
		target_zone.spawn_card(card, index)
	else:
		push_warning("Target zone does not support spawn_card(): " + target_zone.name)
		
func draw_and_place_card(deck_manager: DeckManager, group_name: String, target_zone: Node3D):
	var card_data = deck_manager.draw_card()
	if card_data:
		var card = card_factory.create_card(card_data, group_name)
		zone_manager.move_card_to_zone(card, target_zone)

func _on_card_factory_card_clicked_from_factory(card: Node3D) -> void:
	print("Card clicked signal received:", card.name)

	for i in range(4):
		draw_and_place_card(player_deck_manager, "player_cards", player_hand_zone)
		draw_and_place_card(opponent_deck_manager, "opponent_cards", opponent_hand_zone)
