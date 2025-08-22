extends VBoxContainer

@onready var name_label: Label = $Name
@onready var texture_button: TextureButton = $Sprite
@onready var price_label: Label = $Price

@export var drink_name : String
@export var drink_price : int
@export var drink_image : Texture2D
var description : String

func _ready() -> void:
	name_label.text = drink_name
	texture_button.texture_normal = drink_image
	price_label.text = "$" + str(drink_price)
