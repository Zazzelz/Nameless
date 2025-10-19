extends Node3D
class_name DeckManager

# Path to folder containing CardData .tres resources
const CARD_FOLDER := "res://01_Resources/02_Card_Deck/"

# Loaded base card templates and active deck contents
var base_cards: Array[CardData] = []
var deck: Array[CardData] = []

# Number of cards to generate in the deck
@export var deck_size: int = 10

func _ready():
	# Initialize deck on scene load
	randomize()
	load_base_cards()
	generate_deck(deck_size)
	shuffle_deck()
	print_deck_summary()

func load_base_cards():
	# Loads all .tres files in CARD_FOLDER into base_cards
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
				push_warning("Invalid CardData file: " + full_path)
		file_name = dir.get_next()
	dir.list_dir_end()

func generate_deck(size: int):
	# Randomly fills deck with duplicated base cards up to specified size
	deck.clear()
	for i in range(size):
		var random_card = base_cards[randi() % base_cards.size()]
		deck.append(random_card.duplicate())

func shuffle_deck():
	# Randomizes deck order
	deck.shuffle()

func draw_card() -> CardData:
	# Removes and returns the top card from the deck
	return deck.pop_front() if deck.size() > 0 else null

func get_remaining_cards() -> Array[CardData]:
	# Returns current deck contents
	return deck

func print_deck_summary():
	# Prints all cards currently in the deck
	print("Deck initialized with %d cards:" % deck.size())
	for card_data in deck:
		print("- %s" % card_data.card_name)

func peek_card(index: int) -> CardData:
	if index >= 0 and index < deck.size():
		return deck[index]
	push_warning("peek_card index out of bounds: %d" % index)
	return null
	
func mark_card_as_drawn(card_id: String) -> void:
	for i in range(deck.size()):
		if deck[i].id == card_id:
			deck.remove_at(i)
			return
	push_warning("Card ID not found in deck: %s" % card_id)
