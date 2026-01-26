extends Marker3D
class_name HandZone  

@export var zone_owner: String = "player"

# How wide the fan should be (meters)
@export var max_hand_width := 2.0

# Angle to tilt the cards toward camera
@export var tilt_angle := -70.0

# Total fan spread in degrees
@export var fan_angle_deg := 30.0

# Z stacking offset between left→right cards
@export var max_z_offset := 0.05

# Hand scaling
@export var hand_scale := 1.0         # Normal card scale
@export var hover_hand_scale := 0.85  # Shrink hovered card

var hovered_card: Card = null

func _ready() -> void:
	set_meta("zone_type", "hand")
	set_meta("owner", zone_owner)
	layout_hand()  # Initial layout

# ------------------------------------------------------------------------------

func layout_hand() -> void:
	var cards := get_children().filter(func(c): return c is Card)
	if cards.size() == 0:
		return

	var count := cards.size()
	var max_fan_angle := deg_to_rad(fan_angle_deg)

	for i in range(count):
		var card: Card = cards[i]

		# Assign hand index
		card.set_meta("hand_index", i)

		# Normalized position in fan: -0.5 to 0.5
		var t := 0.0
		if count > 1:
			t = float(i) / float(count - 1) - 0.5

		# Angle offset for outward fan
		var angle_offset := t * max_fan_angle

		# Position along arc
		var radius := max_hand_width / max_fan_angle
		var x_pos := sin(angle_offset) * radius
		var z_pos := -cos(angle_offset) * radius + radius

		# Stack left-to-right: leftmost card on top
		var stack_z := (count - 1 - i) * max_z_offset
		z_pos += stack_z

		var target_pos := Vector3(x_pos, 0, z_pos)
		var target_rot := Vector3(deg_to_rad(tilt_angle), -angle_offset, 0)

		# Store base layout for hover effects
		card.set_meta("layout_pos", target_pos)
		card.set_meta("layout_rot", target_rot)

		# Set initial target for smooth movement
		card.set_meta("target_pos", target_pos)
		card.set_meta("target_rot", target_rot)

		# Apply initial transform
		card.transform = Transform3D(Basis()
										.rotated(Vector3(1,0,0), target_rot.x)
										.rotated(Vector3(0,1,0), target_rot.y)
										.rotated(Vector3(0,0,1), target_rot.z),
									target_pos)
		
		# Reset scale
		card.scale = Vector3(hand_scale, hand_scale, hand_scale)

	DebugTools.log("HandZone.Layout", "[%s] Hand laid out with %d cards" % [zone_owner, count])

# ------------------------------------------------------------------------------

# Update scales when a card is hovered or unhovered
func update_hand_hover(hovered: Card) -> void:
	hovered_card = hovered
	for card in get_children():
		if card is Card:
			if card == hovered_card:
				# Hovered card shrinks
				card.scale = Vector3(hover_hand_scale, hover_hand_scale, hover_hand_scale)
			else:
				# Other cards return to normal scale
				card.scale = Vector3(hand_scale, hand_scale, hand_scale)
