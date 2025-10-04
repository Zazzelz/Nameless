extends Node

var deck: Array[CardData] = []

func _ready():
	load_deck()
	shuffle_deck()

func load_deck():
	deck.clear()
	deck.append(preload("res://05_Cards/00_Card_Deck/AdvantageCard.tres"))
	deck.append(preload("res://05_Cards/00_Card_Deck/PenaltyCard.tres"))
	deck.append(preload("res://05_Cards/00_Card_Deck/DisadvantageCard.tres"))
	deck.append(preload("res://05_Cards/00_Card_Deck/DoubleDiceCard.tres"))
	deck.append(preload("res://05_Cards/00_Card_Deck/BoostCard.tres"))


func shuffle_deck():
	deck.shuffle()

func draw_card() -> CardData:
	if deck.size() > 0:
		return deck.pop_front()
	return null
