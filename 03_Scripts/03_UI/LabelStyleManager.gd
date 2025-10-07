extends Node

const LABEL_STYLE_FOLDER := "res://01_Resources/01_Label_Styles/"
var label_styles: Dictionary = {}

func _ready():
	load_label_styles()

func load_label_styles():
	label_styles.clear()

	var dir := DirAccess.open(LABEL_STYLE_FOLDER)
	if dir == null:
		push_error("Label style folder not found: " + LABEL_STYLE_FOLDER)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tres"):
			var full_path = LABEL_STYLE_FOLDER + "/" + file_name
			var style = load(full_path)
			if style:
				var key = file_name.get_basename() # e.g. "PlayerWinSettings"
				label_styles[key] = style
			else:
				push_warning("Invalid label style file: " + full_path)
		file_name = dir.get_next()
	dir.list_dir_end()
