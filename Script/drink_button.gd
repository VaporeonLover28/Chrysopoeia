extends VBoxContainer

@onready var name_label: Label = $Name
@onready var texture_button: TextureButton = $Sprite
@onready var label_v_box: HBoxContainer = $Label_V_Box
@onready var price_label: Label = $Label_V_Box/Price
@onready var in_inv_label: Label = $Label_V_Box/InInv

@export var drink_name : String
@export var drink_price : int
@export var drink_image : Texture2D
var description : String

func _ready() -> void:
	name_label.text = drink_name
	texture_button.texture_normal = drink_image
	price_label.text = "$" + str(drink_price)
	in_inv_label.text = "Owned: " + "0"
