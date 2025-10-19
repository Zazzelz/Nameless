extends Node
class_name CardFactory
# Preloaded card scene and unique ID counter
const card_scene := preload("res://02_Scenes/03_Cards/3DCard.tscn")
var card_index := 0

# Signals for card interactions
signal card_clicked_from_factory(card: Node3D)
signal card_dropped_from_factory(card: Node3D, target_zone: Node3D)

func create_card(card_data: CardData, group_name: String = "player_cards") -> Node3D:
	# Instantiates a card, sets data, and connects interaction signals
	if not card_data:
		push_error("CardFactory received null CardData")
		return null

	var card := card_scene.instantiate()
	card.name = "Card_%d" % card_index
	card_index += 1

	card.set_card_data(card_data)
	card.add_to_group(group_name)

	card.connect("card_clicked", Callable(self, "_on_card_clicked"))
	card.connect("card_dropped", Callable(self, "_on_card_dropped"))

	return card

func _on_card_clicked(card: Node3D):
	# Relay click signal to external listeners
	card_clicked_from_factory.emit(card)

func _on_card_dropped(card: Node3D, target_zone: Node3D):
	# Relay drop signal to external listeners
	card_dropped_from_factory.emit(card, target_zone)
