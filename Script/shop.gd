extends Control

@onready var buyable_object = preload("res://Scenes/buyable_object.tscn")
@onready var sections_of_shop: TabContainer = $"MarginContainer/VBoxContainer/HBoxContainer/Sections of shop"
@onready var games_h_box_container: HBoxContainer = $"MarginContainer/VBoxContainer/HBoxContainer/Sections of shop/Games/ScrollContainer/HBoxContainer"
@onready var decoration_h_box_container: HBoxContainer = $"MarginContainer/VBoxContainer/HBoxContainer/Sections of shop/Decoration/ScrollContainer/GridContainer"
@onready var spell_h_box_container: HBoxContainer = $"MarginContainer/VBoxContainer/HBoxContainer/Sections of shop/Spells/ScrollContainer/HBoxContainer"
@onready var spell_option_box_container: HBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer/Spell_choice_container/HBoxContainer
@onready var world_scene = $"../../"
@onready var money_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/Label

signal wait_for_spell_change

func _ready() -> void:
	get_parent().visible = false
	pass
	
func _show_shop_menu():
	get_parent().visible = true
	Globals.game_paused = true
	sections_of_shop.visible = true
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
			spell_h_box_container.add_child(instanciated_item)
			instanciated_item.position.x += 245 + (item * 245)
			


func _buy_item(object_being_purchase: Control):
	if object_being_purchase.item_resource.price <= Globals.money:
		Globals.money -= object_being_purchase.item_resource.price
		if object_being_purchase.item_resource.item_type == "Objects":
			world_scene.get_node("Player")._start_bulding_phase(object_being_purchase.item_resource.item_scene)
		else:
			if Globals.spell_inventory_list.size() < 2:
				Globals.spell_inventory_list.push_front(object_being_purchase.item_resource)
			else:
				for item in Globals.spell_inventory_list.size():
					var instancieted_spell_choice = buyable_object.instantiate()
					instancieted_spell_choice.item_resource = Globals.spell_inventory_list[item - 1]
					instancieted_spell_choice.get_child(0).get_node("Button").connect("pressed", _choose_spell_to_change.bind(instancieted_spell_choice))
					spell_option_box_container.add_child(instancieted_spell_choice)
				sections_of_shop.visible = false
				spell_option_box_container.visible = true
				await wait_for_spell_change
				Globals.spell_inventory_list.push_front(object_being_purchase.item_resource)
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
				
		if spell_option_box_container.get_child_count() > 0:
			for item in spell_option_box_container.get_child_count():
				spell_option_box_container.get_child(item- 1).queue_free()

func _choose_spell_to_change(spell_choosen: Control):
	var spell_to_remove = Globals.spell_inventory_list.find(spell_choosen.item_resource)
	Globals.spell_inventory_list.remove_at(spell_to_remove)
	wait_for_spell_change.emit()
