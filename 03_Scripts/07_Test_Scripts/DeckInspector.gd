extends Node
class_name DeckInspector

# ------------------------------------------------------------------------------
# DeckInspector
# Utility node for reading and printing deck JSON files.
# Primarily used for debugging deck structure during development.
# ------------------------------------------------------------------------------

func _ready() -> void:
	# Automatically inspect the default deck on startup
	read_deck_json("user://decks/default_deck.json")


# ------------------------------------------------------------------------------
# JSON Deck Reader
# Loads a deck file from disk and logs its contents for inspection.
# ------------------------------------------------------------------------------

func read_deck_json(path: String) -> void:
	if not FileAccess.file_exists(path):
		DebugTools.warn("DeckInspector.Errors", "Deck file not found at: %s" % path)
		return

	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		DebugTools.warn("DeckInspector.Errors", "Failed to open deck file at: %s" % path)
		return

	var json_text: String = file.get_as_text()
	var result: Variant = JSON.parse_string(json_text)


	if result is Dictionary:
		DebugTools.log("DeckInspector.Read", "📦 Deck contents:")
		for key in result.keys():
			DebugTools.log("DeckInspector.Read", "  %s: %s" % [key, result[key]])
	else:
		DebugTools.warn("DeckInspector.Errors", "Invalid JSON format in deck file: %s" % path)
