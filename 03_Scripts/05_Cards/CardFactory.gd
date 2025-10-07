extends Node

const card_scene := preload("res://02_Scenes/03_Cards/3DCard.tscn")
# Tracks unique card names for debugging and clarity
var card_index := 0

func create_card(card_data: CardData, group_name: String = "player_cards") -> Node3D:
	# Load and instantiate the card scene
	if not card_data:
		push_error("CardFactory received null CardData")
		return null
		
	var card := card_scene.instantiate()
	card.name = "Card_" + str(card_index)
	card_index += 1
	
	if card_data.skin_id != "":
		card.add_to_group("skin_" + card_data.skin_id)
	# Assign card data and add to group
	card.set_card_data(card_data)
	card.add_to_group(group_name)

	# Connect interaction signal (optional for MVP)
	if not card.is_connected("card_clicked", Callable(self, "_on_card_clicked")):
		card.connect("card_clicked", Callable(self, "_on_card_clicked"))
		
		
	print("Card created")
	return card

signal card_clicked_from_factory(card: Node3D)

func _on_card_clicked(card: Node3D):
	print("Card clicked:", card.name)
	card_clicked_from_factory.emit(card)
