extends Control

@onready var buyable_object = preload("res://Scenes/buyable_object.tscn")
@onready var shop_tabs: TabContainer = $Margin/Top_Bar/Shop_Tabs
@onready var games_h_box_container: HBoxContainer = $Margin/Top_Bar/Shop_Tabs/Games/ScrollContainer/HBoxContainer
@onready var decoration_h_box_container: HBoxContainer = $Margin/Top_Bar/Shop_Tabs/Decoration/ScrollContainer/HBoxContainer
@onready var spell_h_box_container: HBoxContainer = $Margin/Top_Bar/Shop_Tabs/Spells/ScrollContainer/HBoxContainer
@onready var spell_option_box_container: PanelContainer = $"../Inv_Full_Choice"
@onready var spell_slot1: TextureRect = $"../Inv_Full_Choice/VBoxContainer/Margin/HBoxContainer/slot1/TextureRect"
@onready var spell_slot2: TextureRect = $"../Inv_Full_Choice/VBoxContainer/Margin/HBoxContainer/slot2/TextureRect"
@onready var world_scene = $"../../"
@onready var money_label: Label = $Margin/Top_Bar/Money_Label
@onready var ring_door = $"../../NavigationRegion3D/cassino/door4"

signal wait_for_spell_change
signal update_hud

func _ready() -> void:
	get_parent().visible = false
	
func _show_shop_menu():
	get_parent().visible = true
	Globals.game_paused = true
	shop_tabs.visible = true
	spell_option_box_container.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	money_label.text = "Money: " + str(Globals.money)
	
	if PurchasableItemList.games_list.size() > 0:
		for item in PurchasableItemList.games_list.size():
			var instanciated_item = buyable_object.instantiate()
			instanciated_item.item_resource = PurchasableItemList.games_list[item - 1]
			instanciated_item.get_child(0).get_node("Button").connect("pressed", _buy_item.bind(instanciated_item))
			instanciated_item.position.x = 245 + (item * 245)
			games_h_box_container.add_child(instanciated_item)
	
	if PurchasableItemList.decoration_list.size() > 0:
		for item in PurchasableItemList.decoration_list.size():
			var instanciated_item = buyable_object.instantiate()
			instanciated_item.item_resource = PurchasableItemList.decoration_list[item - 1]
			instanciated_item.get_child(0).get_node("Button").connect("pressed", _buy_item.bind(instanciated_item))
			instanciated_item.position.x += 245 + (item * 245)
			decoration_h_box_container.add_child(instanciated_item)
			
		
	if PurchasableItemList.spell_list.size() > 0:
		for item in PurchasableItemList.spell_list.size():
			var instanciated_item = buyable_object.instantiate()
			instanciated_item.item_resource = PurchasableItemList.spell_list[item - 1]
			instanciated_item.get_child(0).get_node("Button").connect("pressed", _buy_item.bind(instanciated_item))
			instanciated_item.position.x += 245 + (item * 245)
			spell_h_box_container.add_child(instanciated_item)
			

func _buy_item(object_being_purchased: Control):
	if object_being_purchased.item_resource.price <= Globals.money:
		Globals.money -= object_being_purchased.item_resource.price
		if object_being_purchased.item_resource.item_type == "Objects":
			world_scene.get_node("Player")._start_bulding_phase(object_being_purchased.item_resource.item_scene)
			match [object_being_purchased.item_resource.name, PurchasableItemList.item_list_level]:
				["Slot Machine", 0]:
					PurchasableItemList.item_list_level += 1
				["Black jack", 1]:
					PurchasableItemList.item_list_level += 1
				["Bar", 2]:
					PurchasableItemList.item_list_level += 1
				["Chipped Key", 3]:
					PurchasableItemList.item_list_level += 1
		else:
			if object_being_purchased.item_resource.name == "Chipped Key" and PurchasableItemList.item_list_level <= 3:
				Globals.ring_unlock = true
				ring_door.bought_ring_key.emit()
			elif Globals.spell_inventory_list[0] == null or Globals.spell_inventory_list[1] == null:
				Globals.spell_inventory_list.push_front(object_being_purchased.item_resource)
				update_hud.emit()
			else:
				spell_slot1.texture = Globals.spell_inventory_list[0].item_sprite
				spell_slot1.get_parent().connect("pressed", _choose_spell_to_change.bind(Globals.spell_inventory_list[0]))
				spell_slot1.texture = Globals.spell_inventory_list[0].item_sprite
				spell_slot2.get_parent().connect("pressed", _choose_spell_to_change.bind(Globals.spell_inventory_list[1]))
				shop_tabs.visible = false
				spell_option_box_container.visible = true
				await wait_for_spell_change
				Globals.spell_inventory_list.push_front(object_being_purchased.item_resource)
				update_hud.emit()
				
		match [object_being_purchased.item_resource.name, PurchasableItemList.item_list_level]:
			["Slot Machine", 0]:
				PurchasableItemList.item_list_level += 1
			["Black jack", 1]:
				PurchasableItemList.item_list_level += 1
			["Chipped Key", 2]:
				PurchasableItemList.item_list_level += 1
	
	get_parent().visible = false
	Globals.game_paused = false
		
	if games_h_box_container.get_child_count() > 0:
		for item in games_h_box_container.get_child_count():
			games_h_box_container.get_child(item- 1).queue_free()
		
	if decoration_h_box_container.get_child_count() > 0:
		for item in decoration_h_box_container.get_child_count():
			decoration_h_box_container.get_child(item- 1).queue_free()

	if spell_h_box_container.get_child_count() > 0:
		for item in spell_h_box_container.get_child_count():
			spell_h_box_container.get_child(item- 1).queue_free()

func _choose_spell_to_change(spell_choosen: PurchasableItemResource):
	var spell_to_remove = Globals.spell_inventory_list.find(spell_choosen)
	Globals.spell_inventory_list.remove_at(spell_to_remove)
	wait_for_spell_change.emit()
