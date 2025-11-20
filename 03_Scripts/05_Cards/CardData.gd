extends Resource
class_name CardData

@export var template_id: String = ""      # Unique static ID
@export var card_name: String = ""
@export var description: String = ""
@export var effect_type: String = ""      # "advantage", "penalty", etc.
@export var value: int = 0                # Effect magnitude
@export var icon_texture: Texture2D
@export var skin_id: String = ""          # Optional skin override
@export var tags: Array[String] = []      # Flexible metadata
