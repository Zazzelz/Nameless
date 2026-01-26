extends PanelContainer
class_name DebugPanel

# ------------------------------------------------------------------------------
# DebugPanel
# Collapsible left-side debug UI with:
# - Always-visible header
# - Collapse/expand behavior
# - Global debug toggle
# - Raycast toggle
# - Per-category toggles
# - Reset button
#
# The panel blocks input when expanded, and shrinks to header-only when collapsed.
# ------------------------------------------------------------------------------

@onready var collapse_button: Button = $VBoxContainer/Header/CollapseButton
@onready var enable_debug: CheckBox = $VBoxContainer/EnableDebug
@onready var show_rays: CheckBox = $VBoxContainer/ShowRays
@onready var reset_all: Button = $VBoxContainer/ResetAll
@onready var category_container: VBoxContainer = $VBoxContainer/ScrollContainer/CategoryList

var is_collapsed: bool = false


# ------------------------------------------------------------------------------
# Initialization
# ------------------------------------------------------------------------------

func _ready() -> void:
	# Prevent clicks from leaking into the game world
	mouse_filter = Control.MOUSE_FILTER_STOP
	size_flags_vertical = Control.SIZE_SHRINK_CENTER

	# Connect UI signals
	collapse_button.pressed.connect(_on_collapse_pressed)
	enable_debug.toggled.connect(_on_enable_debug_toggled)
	show_rays.toggled.connect(_on_show_rays_toggled)
	reset_all.pressed.connect(_on_reset_all_pressed)

	_build_category_list()


# ------------------------------------------------------------------------------
# Collapse / Expand
# ------------------------------------------------------------------------------

func _on_collapse_pressed() -> void:
	is_collapsed = !is_collapsed

	$VBoxContainer/EnableDebug.visible = not is_collapsed
	$VBoxContainer/ShowRays.visible = not is_collapsed
	$VBoxContainer/ResetAll.visible = not is_collapsed
	$VBoxContainer/ScrollContainer.visible = not is_collapsed

	# PanelContainer automatically shrinks to fit visible children


# ------------------------------------------------------------------------------
# Global Toggles
# ------------------------------------------------------------------------------

func _on_enable_debug_toggled(state: bool) -> void:
	DebugTools.global_enabled = state


func _on_show_rays_toggled(state: bool) -> void:
	DebugTools.show_rays = state


func _on_reset_all_pressed() -> void:
	DebugTools.reset_all_categories()
	_build_category_list()


# ------------------------------------------------------------------------------
# Category List Builder
# ------------------------------------------------------------------------------

func _build_category_list() -> void:
	# Clear old toggles
	for child in category_container.get_children():
		child.queue_free()

	# Add one checkbox per category
	for category in DebugTools.get_all_categories():
		var toggle := CheckBox.new()
		toggle.text = category
		toggle.button_pressed = DebugTools.is_category_enabled(category)
		toggle.toggled.connect(func(state): DebugTools.set_category_enabled(category, state))
		category_container.add_child(toggle)
