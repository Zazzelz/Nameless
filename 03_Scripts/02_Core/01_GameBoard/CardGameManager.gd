extends Node3D
class_name CardGameManager

@onready var player_deck_manager := find_child("PlayerDeckManager", true, false) as DeckManager
@onready var opponent_deck_manager := find_child("OpponentDeckManager", true, false) as DeckManager
@onready var card_factory := find_child("CardFactory", true, false) as CardFactory
@onready var zone_manager := find_child("ZoneManager", true, false) as ZoneManager

@onready var player_deck_zone := find_child("PlayerDeckZone", true, false)
@onready var opponent_deck_zone := find_child("OpponentDeckZone", true, false)
@onready var player_hand_zone := find_child("PlayerHandZone", true, false)
@onready var opponent_hand_zone := find_child("OpponentHandZone", true, false)
@onready var player_play_zone := find_child("PlayerPlayZone", true, false)
@onready var opponent_play_zone := find_child("OpponentPlayZone", true, false)
@onready var player_discard_zone := find_child("PlayerDiscardZone", true, false)
@onready var opponent_discard_zone := find_child("OpponentDiscardZone", true, false)

func _ready():
	print("CardGameManager is ready")

	# ✅ Register global references
	GameContext.board = self
	GameContext.player_play_zone = player_play_zone
	GameContext.opponent_play_zone = opponent_play_zone

	# ✅ Connect signals
	card_factory.card_clicked_from_factory.connect(Callable(self, "_on_card_clicked"))
	card_factory.card_dropped_from_factory.connect(Callable(self, "_on_card_dropped"))

	_setup_game()

func _setup_game():
	# Spawn all cards into player deck zone
	var player_cards := player_deck_manager.get_remaining_cards()
	for i in range(player_cards.size()):
		var card_data := player_deck_manager.peek_card(i)
		var card := card_factory.create_card(card_data, "player_cards")
		player_deck_zone.spawn_card(card, i)

	# Spawn all cards into opponent deck zone
	var opponent_cards := opponent_deck_manager.get_remaining_cards()
	for i in range(opponent_cards.size()):
		var card_data := opponent_deck_manager.peek_card(i)
		var card := card_factory.create_card(card_data, "opponent_cards")
		opponent_deck_zone.spawn_card(card, i)

func _on_card_clicked(card: Node3D):
	if not card.current_zone:
		print("Card clicked with no zone:", card.name)
		return

	var zone_name: String = card.current_zone.name
	print("Card clicked: %s | Zone: %s" % [card.name, zone_name])

	if card.current_zone == player_deck_zone:
		var deck_cards := []
		for child in player_deck_zone.get_children():
			if child is Card:
				deck_cards.append(child)

		var draw_count := 5
		if deck_cards.size() < draw_count:
			print("Not enough cards to draw %d. Deck has %d cards." % [draw_count, deck_cards.size()])
			return

		for i in range(draw_count):
			var drawn_card: Card = deck_cards[i]
			zone_manager.move_card_to_zone(drawn_card, player_hand_zone)
			player_deck_manager.mark_card_as_drawn(drawn_card.card_id)

		var opponent_deck_cards := []
		for child in opponent_deck_zone.get_children():
			if child is Card:
				opponent_deck_cards.append(child)

		var opponent_draw_count: int
		if opponent_play_zone.get_child_count() > 0:
			opponent_draw_count = 1
		else:
			opponent_draw_count = min(5, opponent_deck_cards.size())

		for i in range(opponent_draw_count):
			var drawn_card: Card = opponent_deck_cards[i]
			zone_manager.move_card_to_zone(drawn_card, opponent_hand_zone)
			opponent_deck_manager.mark_card_as_drawn(drawn_card.card_id)

	elif card.current_zone == opponent_deck_zone:
		var opponent_deck_cards := []
		for child in opponent_deck_zone.get_children():
			if child is Card:
				opponent_deck_cards.append(child)

		var draw_count: int
		if opponent_play_zone.get_child_count() > 0:
			draw_count = 1
		else:
			draw_count = min(5, opponent_deck_cards.size())

		for i in range(draw_count):
			var drawn_card: Card = opponent_deck_cards[i]
			zone_manager.move_card_to_zone(drawn_card, opponent_hand_zone)
			opponent_deck_manager.mark_card_as_drawn(drawn_card.card_id)

func _on_card_dropped(card: Node3D, target_zone: Node3D):
	if card is Card:
		zone_manager.move_card_to_zone(card, target_zone)
	else:
		var root := card
		while root and not (root is Card) and root.get_parent():
			root = root.get_parent()
		if root is Card:
			zone_manager.move_card_to_zone(root, target_zone)
		else:
			push_warning("Dropped node is not a Card: %s" % card.name)

func cleanup_play_zones():
	# move all cards from player play zone to player discard zone 
	for card in player_play_zone.get_children():
		if card is Card: 
			zone_manager.move_card_to_zone(card, player_discard_zone)
		# move all cards from Opponent play zone to Opponent discard zone 
	for card in opponent_play_zone.get_children():
		if card is Card: 
			zone_manager.move_card_to_zone(card, opponent_discard_zone)

func check_and_reshuffle_deck(deck_zone: Node3D, discard_zone: Node3D):
	var deck_cards := []
	for child in deck_zone.get_children():
		if child is Card:
			deck_cards.append(child)

	# If deck is empty, move discard cards back
	if deck_cards.size() == 0:
		var discard_cards := []
		for child in discard_zone.get_children():
			if child is Card:
				discard_cards.append(child)

		if discard_cards.size() == 0:
			print("Both deck and discard are empty! No cards to draw.")
			return

		# Shuffle discard cards
		discard_cards.shuffle()

		# ✅ Move them into deck zone with correct index for proper stacking
		for i in range(discard_cards.size()):
			var card = discard_cards[i]
			discard_zone.remove_child(card)
			zone_manager.move_card_to_zone(card, deck_zone, i)

		print("Deck was empty. Reshuffled discard pile into deck:", deck_zone.name)
