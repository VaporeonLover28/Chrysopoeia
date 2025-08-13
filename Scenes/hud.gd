extends CanvasLayer

@onready var pause: TextureRect = $pause
@onready var money_box: VBoxContainer = $money_box
@onready var shop: TextureRect = $money_box/shop
@onready var spells: MarginContainer = $spells
@onready var slot_1: TextureRect = $spells/magic_box/slot_1
@onready var slot_2: TextureRect = $spells/magic_box/slot_2

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
	if Globals.spell_inventory_list.size() > 1:
		if slot_2.visible == false:
			slot_2.visible = true
		slot_2.get_child(0).texture = Globals.spell_inventory_list[1].item_sprite
		slot_2.get_child(1).text =  "[wave amp=40.0 freq=5.0 connected=1]" + \
		Globals.spell_inventory_list[1].name + "[/wave]"
