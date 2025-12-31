extends Node3D

@onready var factory: CardFactory = CardFactory.new()

var test_results: Array[String] = []


func _ready() -> void:
	print("\n=== SpawnCardTest Start ===")

	add_child(factory)

	# Step 1 — Load card templates
	var card_data := _load_random_card()
	_assert(card_data != null, "Loaded random CardData resource")

	if not card_data:
		_print_summary()
		return

	# Step 2 — Spawn card
	var card_node := factory.create_card(card_data, "player")
	_assert(card_node != null, "CardFactory created a Card node")

	if card_node:
		add_child(card_node)
		card_node.position = Vector3(0, 0, 0)

	# Step 3 — Validate card fields
	_assert(card_data.card_name != "", "Card name is populated")
	_assert(card_data.description != "", "Card description is populated")
	_assert(card_data.template_id != "", "Card template_id is populated")
	_assert(card_data.icon_texture != null, "Card icon texture is assigned")

	# Step 4 — Print full card details
	_print_card_details(card_data)

	# Step 5 — Validate UI population (after deferred apply)
	await get_tree().process_frame
	await get_tree().process_frame

	var ui_ok := _validate_card_ui(card_node)
	_assert(ui_ok, "Card UI populated correctly")

	# Final summary
	_print_summary()

	print("\n=== SpawnCardTest Complete ===")

# Load a random CardData resource
func _load_random_card() -> CardData:
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
		return null

	var random_path := card_files[randi() % card_files.size()]
	print("Loading random card:", random_path)

	var card_data: CardData = load(random_path)
	return card_data

# Print card details
func _print_card_details(card_data: CardData) -> void:
	print("\n--- Card Details ---")
	print("Name:        ", card_data.card_name)
	print("Description: ", card_data.description)
	print("Template ID: ", card_data.template_id)
	print("Effect Type: ", card_data.effect_type)
	print("Value:       ", card_data.value)
	print("Icon:        ", card_data.icon_texture)
	print("---------------------\n")

# Validate UI population
func _validate_card_ui(card: Card) -> bool:
	if not card or not card.sub_viewport:
		return false

	var card_ui := card.sub_viewport.get_node_or_null("CardUi")
	if not card_ui:
		return false

	var name_label := card_ui.get_node_or_null("NameLabel")
	var ability_label := card_ui.get_node_or_null("AbilityLabel")
	var icon := card_ui.get_node_or_null("Icon")

	if not name_label or name_label.text == "":
		return false
	if not ability_label or ability_label.text == "":
		return false
	if not icon or icon.texture == null:
		return false

	return true

# Assertion + Summary
func _assert(condition: bool, message: String) -> void:
	if condition:
		var msg = "[PASS] " + message
		print(msg)
		test_results.append(msg)
	else:
		var msg = "[FAIL] " + message
		push_error(msg)
		test_results.append(msg)

func _print_summary() -> void:
	print("\n=== TEST SUMMARY ===")
	for result in test_results:
		print(result)
	print("====================\n")
