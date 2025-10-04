extends Node3D

@onready var front_face := $FrontFace
@onready var viewport := $SubViewport

func _ready():
	var material := StandardMaterial3D.new()
	material.albedo_texture = viewport.get_texture()
	front_face.material_override = material

func set_card_data(data:CardData):
	var ui := $Subviewport/CardUI
	ui.get_node("NameLabel").text = data.card_name
	ui.get_node("AbilityLabel").text = data.description
	
	var material := StandardMaterial3D.new()
	material.albedo_texture = $Subviewport.get_texture()
	$FrontFace.material_override = material
