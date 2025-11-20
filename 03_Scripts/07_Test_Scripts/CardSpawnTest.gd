extends Node3D

@onready var factory: CardFactory = CardFactory.new()

func _ready() -> void:
	add_child(factory)

	# Load all .tres files from your card list folder
	var dir := DirAccess.open("res://01_Resources/02_Cards/01_Card_List/")
	var card_files: Array[String] = []
	if dir:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tres"):
				card_files.append("res://01_Resources/02_Cards/01_Card_List/" + file_name)
			file_name = dir.get_next()
		dir.list_dir_end()

	if card_files.is_empty():
		push_error("No .tres card files found in Card_List folder")
		return

	# Pick a random file
	var random_path := card_files[randi() % card_files.size()]
	print("Loading random card:", random_path)

	# Load the CardData resource
	var card_data: CardData = load(random_path)
	if not card_data:
		push_error("Failed to load CardData from: %s" % random_path)
		return

	# Spawn card via factory
	var card_node := factory.create_card(card_data, "player")
	add_child(card_node)

	# Position it so you can see it
	card_node.position = Vector3(0, 0, 0)

	# Connect signals for testing
	factory.connect("card_clicked", Callable(self, "_on_card_clicked"))
	factory.connect("card_dropped", Callable(self, "_on_card_dropped"))

	print("Spawned card:", card_data.card_name)

func _on_card_clicked(card: Card) -> void:
	print("Card clicked:", card.card_data.card_name)

func _on_card_dropped(card: Card, target_zone: Node3D) -> void:
	print("Card dropped:", card.card_data.card_name, "into", target_zone.name)
