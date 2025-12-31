extends Node
class_name DeckInspector

# === Debug Toggle ===
@export var debug_enabled: bool = false

func _log(msg: String) -> void:
	if debug_enabled:
		print(msg)

func _warn(msg: String) -> void:
	if debug_enabled:
		push_warning(msg)

func _ready() -> void:
	read_deck_json("user://decks/default_deck.json")

func read_deck_json(path: String) -> void:
	if not FileAccess.file_exists(path):
		_warn("Deck file not found at: %s" % path)
		return

	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		_warn("Failed to open deck file.")
		return

	var json_text := file.get_as_text()
	var result: Dictionary = JSON.parse_string(json_text)

	if result is Dictionary:
		_log("📦 Deck contents:")
		for key in result.keys():
			_log("  %s: %s" % [key, result[key]])
	else:
		_warn("Invalid JSON format in deck file.")
