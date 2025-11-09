extends Resource
class_name CardData

@export var template_id: String = ""  # ✅ Add this line
@export var card_name: String
@export var description: String
@export var effect_type: String # e.g., "advantage", "disadvantage", "penalty", "double_roll"
@export var value: int # Used for penalty amount, etc.
@export var icon_texture: Texture2D
@export var skin_id: String = ""
@export var tags: Array[String] = []
