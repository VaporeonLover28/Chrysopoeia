extends Resource; class_name PurchasableItemResource

@export_enum("Objects", "Spells") var item_type: String
@export var name: String
@export var price: int
@export var description: String
@export var item_scene: PackedScene
#only necessary if it is a spell 
@export var item_sprite: Texture2D
@export var usable: bool = true
