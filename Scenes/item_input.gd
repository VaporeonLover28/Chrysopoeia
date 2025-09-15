extends Control

@onready var sprite: TextureRect = $HBoxContainer/TextureRect
@onready var label: Label = $HBoxContainer/Label

@export var icon : Texture
@export var text : String

func _ready() -> void:
	sprite.texture = icon
	label.text = text
