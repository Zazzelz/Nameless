extends Node3D

class_name  DeckManager

const CARD_FOLDER := "res://01_Resources/02_Card_Deck/"
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

	var dir := DirAccess.open(CARD_FOLDER)
	if dir == null:
		push_error("Card folder not found: " + CARD_FOLDER)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tres"):
			var full_path = CARD_FOLDER + "/" + file_name
			var card_data = load(full_path)
			if card_data is CardData:
				base_cards.append(card_data)
			else:
				push_warning("File is not a valid CardData: " + full_path)
		file_name = dir.get_next()
	dir.list_dir_end()

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
