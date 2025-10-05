extends Node3D

var base_cards: Array[CardData] = []
var deck: Array[CardData] = []

@export var deck_size: int = 20 # You can change this from the editor or dynamically

func _ready():
	randomize()
	load_base_cards()
	generate_deck(deck_size)
	shuffle_deck()

func load_base_cards():
	base_cards.clear()
	base_cards.append(preload("res://05_Cards/00_Card_Deck/AdvantageCard.tres"))
	base_cards.append(preload("res://05_Cards/00_Card_Deck/PenaltyCard.tres"))
	base_cards.append(preload("res://05_Cards/00_Card_Deck/DisadvantageCard.tres"))
	base_cards.append(preload("res://05_Cards/00_Card_Deck/DoubleDiceCard.tres"))
	base_cards.append(preload("res://05_Cards/00_Card_Deck/BoostCard.tres"))

func generate_deck(size: int):
	deck.clear()
	for i in range(size):
		var random_card = base_cards[randi() % base_cards.size()]
		deck.append(random_card.duplicate()) # Duplicate to avoid shared references

func shuffle_deck():
	deck.shuffle()

func draw_card() -> CardData:
	if deck.size() > 0:
		return deck.pop_front()
	return null
