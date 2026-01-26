extends Node3D
class_name ZoneManager

# ------------------------------------------------------------------------------
# ZoneManager
# Discovers and registers all zone nodes in the scene tree.
# Responsibilities:
# - Build a dictionary of zones keyed by "owner_zoneType"
# - Assign metadata required by Card and CardFactory
# - Provide camera references to zones that need them (e.g., HandZone)
# ------------------------------------------------------------------------------

var camera: Camera3D
var zones: Dictionary = {}   # key → Node3D (e.g., "player_hand")


# ------------------------------------------------------------------------------
# Initialization
# ------------------------------------------------------------------------------

func _ready() -> void:
	DebugTools.log("ZoneManager.Init", "ZoneManager ready")

	_register_zones()

	if camera:
		_assign_camera_to_hand_zones()


# ------------------------------------------------------------------------------
# Zone Registration
# Scans child nodes to build the zone dictionary.
# Expected structure:
#   PlayerNode/
#       PlayerHandZone
#       PlayerDeckZone
#       PlayerPlayZone
#       PlayerDiscardZone
#   OpponentNode/
#       ...
# ------------------------------------------------------------------------------

func _register_zones() -> void:
	zones.clear()

	for owner_node in get_children():
		if not (owner_node is Node3D):
			continue

		var owner: String = owner_node.name.replace("Node", "").to_lower()

		for zone in owner_node.get_children():
			if not (zone is Node3D):
				continue

			var zone_type: String = zone.name.replace(owner_node.name.replace("Node", ""), "")
			zone_type = zone_type.replace("Zone", "").to_lower()

			var key: String = "%s_%s" % [owner, zone_type]

			zones[key] = zone
			zone.set_meta("zone_key", key)
			zone.set_meta("owner", owner)

			# Required by Card.update_zone_info()
			zone.set_meta("zone_type", zone_type)

			DebugTools.log("ZoneManager.Register", "Registered zone: %s" % key)


# ------------------------------------------------------------------------------
# Camera Assignment
# Only the player's hand zone requires a camera reference.
# ------------------------------------------------------------------------------

func _assign_camera_to_hand_zones() -> void:
	for key in zones.keys():
		if key == "player_hand":
			var hand_zone: Node = zones[key]
			if hand_zone.has_method("set_camera"):
				hand_zone.set_camera(camera)
				DebugTools.log("ZoneManager.Camera", "Camera assigned to player hand zone")


func set_camera(cam: Camera3D) -> void:
	camera = cam
	_assign_camera_to_hand_zones()


# ------------------------------------------------------------------------------
# Lookup Helpers
# ------------------------------------------------------------------------------

func get_zone_key_from_node(node: Node) -> String:
	for key in zones.keys():
		if zones[key] == node:
			return key
	return ""
