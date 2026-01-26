extends Node
# ------------------------------------------------------------------------------
# DebugTools
# Centralized debug logging system with:
# - Global enable/disable
# - Per-category filtering
# - Raycast visualization toggle
# - Reset functionality
#
# All gameplay scripts should call DebugTools.log() or DebugTools.warn()
# instead of print() or push_warning().
# ------------------------------------------------------------------------------

# --- Global Toggles ------------------------------------------------------------
var global_enabled: bool = true
var show_rays: bool = false

# --- Category State ------------------------------------------------------------
# Add categories here as they appear in your logs.
# DebugPanel will automatically build UI toggles for each one.
var category_states := {
	"CardFactory.Spawn": true,
	"CardFactory.Errors": true,

	"DeckZone.Init": true,
	"DeckZone.Layout": true,
	"DeckZone.Input": true,     # ★ UPDATED
	"DeckZone.Raycast": true,   # ★ UPDATED
	"DeckZone.Errors": true,

	"HandZone.Init": true,
	"HandZone.Camera": true,
	"HandZone.Layout": true,
	"HandZone.Errors": true,

	"PlayZone.Init": true,
	"PlayZone.Layout": true,
	"PlayZone.Errors": true,

	"DiscardZone.Init": true,
	"DiscardZone.Layout": true,
	"DiscardZone.Errors": true,

	"GameUI.Init": true,
	"GameUI.Input": true,
	"GameUI.Errors": true,

	"TurnManager.Init": true,
	"TurnManager.Flow": true,
	"TurnManager.Errors": true,
	
	"CardGameManager.Dealing": true
}

# ------------------------------------------------------------------------------
# Category Helpers (used by DebugPanel)
# ------------------------------------------------------------------------------

func get_all_categories() -> Array:
	return category_states.keys()


func is_category_enabled(category: String) -> bool:
	return category_states.get(category, false)


func set_category_enabled(category: String, state: bool) -> void:
	category_states[category] = state


func reset_all_categories() -> void:
	for key in category_states:
		category_states[key] = true


# ------------------------------------------------------------------------------
# Logging API
# ------------------------------------------------------------------------------
func log(category: String, message: String) -> void:
	if not global_enabled:
		return
	if not category_states.get(category, false):
		return

	print("[%s] %s" % [category, message])


func warn(category: String, message: String) -> void:
	if not global_enabled:
		return
	if not category_states.get(category, false):
		return

	push_warning("[%s] %s" % [category, message])
