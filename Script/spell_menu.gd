extends CanvasLayer

@onready var spells: MarginContainer = $spells
@onready var slot_1: TextureRect = $spells/magic_box/slot_1
@onready var slot_2: TextureRect = $spells/magic_box/slot_2

func load_slots(game : String):
	slot_1.visible = false
	slot_2.visible = false
	
	match game:
		"Blackjack":
			Globals.limit_spells(["Eye of Providence", "Fool's Gold", "Philosopher's Shard"])
		"Fight Ring":
			Globals.limit_spells(["Mars"])
	update_spell_slots()

func update_spell_slots():
	if Globals.spell_inventory_list.size() > 0:
		if slot_1.visible == false:
			slot_1.visible = true
		slot_1.get_child(0).texture = Globals.spell_inventory_list[0].item_sprite
		slot_1.get_child(1).text = "[wave amp=40.0 freq=5.0 connected=1]" + \
		Globals.spell_inventory_list[0].name + "[/wave]"
		slot_1.get_child(2).texture = \
		load("res://Assets/Exports/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_"\
		 + Globals.spell_inventory_list[0].keybind +".png")
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
		slot_2.get_child(2).texture = \
		load("res://Assets/Exports/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_"\
		 + Globals.spell_inventory_list[1].keybind +".png")
		if !Globals.spell_inventory_list[1].usable:
			slot_2.modulate = Color(0.553, 0.553, 0.553)
		else:
			slot_2.modulate = Color(1, 1, 1)
