# ZoneManager.gd
extends Node
@onready var player_deck_zone: Node3D = find_child("PlayerDeckZone", true, false)
@onready var opponent_deck_zone: Node3D = find_child("OpponentDeckZone", true, false)
@onready var player_hand_zone: Node3D = find_child("PlayerHandZone", true, false)
@onready var opponent_hand_zone: Node3D = find_child("OpponentHandZone", true, false)

func move_card_to_zone(card: Node3D, zone: Node3D):
	print("ZoneManager: moving card to ", zone.name)
	if zone.has_method("spawn_card"):
		var index = zone.get_child_count()
		zone.spawn_card(card, index)
	else:
		push_warning("Zone does not support spawn_card(): " + zone.name)
