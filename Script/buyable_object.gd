extends Control

@onready var name_label: Label = $VBoxContainer/Label
@onready var description_label: Label = $VBoxContainer/Label2
@onready var item_viewport: SubViewport = $VBoxContainer/SubViewport
@onready var purchase_button: Button = $VBoxContainer/Button
@onready var item_resource: PurchasableItemResource
@onready var texture_rect: TextureRect = $VBoxContainer/Panel/TextureRect


func _ready() -> void:
	name_label.text = item_resource.name
	description_label.text = item_resource.description
	purchase_button.text = str(item_resource.price)
	var instanciated_item 
	if item_resource.item_type == "Objects":
		instanciated_item = item_resource.item_scene.instantiate()
		if instanciated_item is GambleSpot:
			var instanciated_model = instanciated_item.get_node("Model").duplicate()
			item_viewport.get_child(0).add_child(instanciated_model)
		else:
			item_viewport.get_child(0).add_child(instanciated_item)
	else:
		texture_rect.texture = item_resource.item_sprite
		
func _physics_process(delta: float) -> void:
	if texture_rect.texture is ViewportTexture:
		item_viewport.get_child(0).get_child(-1).rotation += Vector3(0,0.01,0)
