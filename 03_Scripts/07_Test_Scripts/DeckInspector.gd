extends Node
class_name DeckInspector

func _ready() -> void:
	read_deck_json("user://decks/default_deck.json")

func read_deck_json(path: String) -> void:
	if not FileAccess.file_exists(path):
		push_error("Deck file not found at: %s" % path)
		return

	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("Failed to open deck file.")
		return

	var json_text := file.get_as_text()
	var result: Dictionary = JSON.parse_string(json_text)


	if result is Dictionary:
		print("📦 Deck contents:")
		for key in result.keys():
			print("  %s: %s" % [key, result[key]])
	else:
		push_error("Invalid JSON format in deck file.")
