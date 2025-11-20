extends Node
class_name CardFactory

const CARD_SCENE: PackedScene = preload("res://02_Scenes/03_Cards/3DCard.tscn")
var card_index: int = 0

signal card_clicked(card: Card)
signal card_dropped(card: Card, target_zone: Node3D)

func create_card(card_data: CardData, owner: String = "player", zone_node: Node3D = null, reuse_card: Card = null) -> Card:
	if not card_data:
		push_error("CardFactory received null CardData")
		return null

	var card: Card = reuse_card if reuse_card else CARD_SCENE.instantiate()
	card.name = "Card_%d" % card_index
	card_index += 1

	card.setup_from_data(card_data, zone_node, card.name)
	card.zone_owner = owner
	card.add_to_group("%s_cards" % owner)

	_connect_card_signals(card)
	return card

func _connect_card_signals(card: Card) -> void:
	if not card.is_connected("card_clicked", Callable(self, "_on_card_clicked")):
		card.connect("card_clicked", Callable(self, "_on_card_clicked"))
	if not card.is_connected("card_dropped", Callable(self, "_on_card_dropped")):
		card.connect("card_dropped", Callable(self, "_on_card_dropped"))

func _on_card_clicked(card: Card) -> void:
	card_clicked.emit(card)

func _on_card_dropped(card: Card, target_zone: Node3D) -> void:
	card_dropped.emit(card, target_zone)
