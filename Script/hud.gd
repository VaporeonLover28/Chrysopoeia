extends CanvasLayer

@onready var pause: TextureRect = $pause
@onready var money_box: VBoxContainer = $money_box
@onready var shop: TextureRect = $money_box/shop
@onready var spells: MarginContainer = $spells
@onready var slot_1: TextureRect = $spells/magic_box/slot_1
@onready var slot_2: TextureRect = $spells/magic_box/slot_2
@onready var item: RichTextLabel = $crosshair_item/VBoxContainer/name
@onready var crosshair_desc: VBoxContainer = $crosshair_item/VBoxContainer

var prompt = preload("res://Scenes/item_input.tscn")
var all_prompts_shown : bool = false

func _ready() -> void:
	slot_1.visible = false
	slot_2.visible = false
	update_spell_slots()

func update_spell_slots():
	if Globals.spell_inventory_list.size() > 0:
		if slot_1.visible == false:
			slot_1.visible = true
		slot_1.get_child(0).texture = Globals.spell_inventory_list[0].item_sprite
		slot_1.get_child(1).text = "[wave amp=40.0 freq=5.0 connected=1]" + \
		Globals.spell_inventory_list[0].name + "[/wave]"
		if !Globals.spell_inventory_list[0].usable:
			slot_1.modulate = Color(0.553, 0.553, 0.553)
		else:
			slot_1.modulate = Color(1, 1, 1)
	if Globals.spell_inventory_list.size() > 1:
		if slot_2.visible == false:
			slot_2.visible = true
		slot_2.get_child(0).texture = Globals.spell_inventory_list[1].item_sprite
		slot_2.get_child(1).text =  "[wave amp=40.0 freq=5.0 connected=1]" + \
		Globals.spell_inventory_list[1].name + "[/wave]"
		if !Globals.spell_inventory_list[1].usable:
			slot_2.modulate = Color(0.553, 0.553, 0.553)
		else:
			slot_2.modulate = Color(1, 1, 1)

func add_crosshair_input_prompt(text : String, sprite : Texture):
	var new_prompt = prompt.instantiate()
	new_prompt.text = text
	new_prompt.icon = sprite
	new_prompt.scale = Vector2(0.6, 0.6)
	crosshair_desc.add_child(new_prompt)

func clear_desc():
	if crosshair_desc.get_child_count() > 1:
		for child in crosshair_desc.get_children():
			if child is not RichTextLabel:
				child.queue_free()
	all_prompts_shown = false
