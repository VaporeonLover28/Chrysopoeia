extends Control

@onready var name_label: Label = $MarginContainer/VBoxContainer/Name
@onready var chain: TextureRect = $chain
@onready var locknumber: Label = $chain/locknumber
@onready var desc: Label = $MarginContainer/VBoxContainer/Desc
@onready var buy: Button = $MarginContainer/VBoxContainer/Buy
@onready var sprite_rect: TextureRect = $MarginContainer/VBoxContainer/textures/SpriteRect
@onready var subviewport_rect: TextureRect = $MarginContainer/VBoxContainer/textures/SubviewportRect
@onready var pivot: Node3D = $SubViewport/Node3D/Node3D
@onready var world3D: Node3D = $SubViewport/Node3D
@onready var dim: ColorRect = $dim

@export var item : Resource
@export var unlocked : bool
	#set(value):
		#unlocked = value
		#update()

var t : float

func _process(delta: float) -> void:
	t += 0.03
	pivot.rotation_degrees.y = 30 * sin(t) + delta

func _ready() -> void:
	name_label.text = item.name
	desc.text = item.description
	buy.text = "Buy for " + str(item.price) + " Gold"
	locknumber.text = str(item.required_satis)

func update():
	match item.item_type:
		"Objects":
			subviewport_rect.visible = true
			if world3D.get_child_count() > 3:
				world3D.get_children()[3].queue_free()
			var model = item.model.instantiate()
			world3D.add_child(model)
			sprite_rect.visible = false
		"Spells":
			subviewport_rect.visible = false
			sprite_rect.texture = item.item_sprite
			sprite_rect.visible = true
	
	if item.required_satis <= Globals.satisfaction_level:
		unlocked = true
	else:
		unlocked = false
	
	if unlocked:
		dim.visible = false
		chain.visible = false
	else:
		dim.visible = true
		chain.visible = true
