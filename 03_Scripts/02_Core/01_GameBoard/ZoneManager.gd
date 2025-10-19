extends Node
class_name ZoneManager

@onready var player_deck_zone := find_child("PlayerDeckZone", true, false)
@onready var opponent_deck_zone := find_child("OpponentDeckZone", true, false)
@onready var player_hand_zone := find_child("PlayerHandZone", true, false)
@onready var opponent_hand_zone := find_child("OpponentHandZone", true, false)
@onready var player_play_zone := find_child("PlayerPlayZone", true, false)
@onready var opponent_play_zone := find_child("OpponentPlayZone", true, false)

func move_card_to_zone(card: Card, target_zone: Node3D, index := -1):
	if not card or not target_zone:
		push_warning("Missing card or target zone")
		return

	if card.get_parent() == target_zone:
		print("Card already in zone:", target_zone.name)
		return

	if card.get_parent():
		card.get_parent().remove_child(card)

	card.current_zone = target_zone

	var spawn_index: int
	if index >= 0:
		spawn_index = index
	else:
		spawn_index = target_zone.get_child_count()

	if target_zone.has_method("spawn_card"):
		target_zone.spawn_card(card, spawn_index)
	else:
		target_zone.add_child(card)
		card.global_transform.origin = target_zone.global_transform.origin




func print_zone_summary(hand_zone: Node3D, play_zone: Node3D, deck_manager: DeckManager, label: String):
	print("%s Hand zone has %d cards" % [label, hand_zone.get_child_count()])
	print("%s Play zone has %d cards" % [label, play_zone.get_child_count()])
	deck_manager.print_remaining_cards()
