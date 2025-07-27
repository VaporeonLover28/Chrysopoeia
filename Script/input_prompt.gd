extends Node3D

@onready var sprite: Sprite3D = $sprite
@onready var label: Label3D = $label

@export var texture : Texture
@export var action : String 

func _ready() -> void:
	sprite.texture = texture
	label.text = action
