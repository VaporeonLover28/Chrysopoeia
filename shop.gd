extends Control

@onready var buyable_object = preload("res://Scenes/buyable_object.tscn")
@onready var games_h_box_container: HBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer/TabContainer/Games/ScrollContainer/HBoxContainer
@onready var decoration_h_box_container: HBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer/TabContainer/Decoration/ScrollContainer/HBoxContainer
@onready var spell_h_box_container: HBoxContainer = $MarginContainer/VBoxContainer/HBoxContainer/TabContainer/Spells/ScrollContainer/HBoxContainer
@onready var world_scene = $"../../"
@onready var money_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/Label


func _ready() -> void:
	get_parent().visible = false
	
func _show_shop_menu():
	get_parent().visible = true
	Globals.game_paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	money_label.text = "Money: " + str(Globals.money)
	
	if PurchasableItemList.games_list.size() != 0:
		for item in PurchasableItemList.games_list.size():
			var instanciated_item = buyable_object.instantiate()
			print(instanciated_item.get_child(0).get_node("Button"))
			instanciated_item.item_resource = PurchasableItemList.games_list[item - 1]
			instanciated_item.get_child(0).get_node("Button").connect("pressed", _buy_item.bind(instanciated_item))
			games_h_box_container.add_child(instanciated_item)
			instanciated_item.position.x = 500
	
	if PurchasableItemList.decoration_list.size() != 0:
		for item in PurchasableItemList.decoration_list.size():
			var instanciated_item = buyable_object.instantiate()
			instanciated_item.item_resource = PurchasableItemList.decoration_list[item - 1]
			instanciated_item.get_child(0).get_node("button").connect("pressed", _buy_item.bind(instanciated_item))
			decoration_h_box_container.add_child(instanciated_item)
		
	if PurchasableItemList.spell_list.size() != 0:
		for item in PurchasableItemList.spell_list.size() - 1:
			var instanciated_item = buyable_object.instantiate()
			instanciated_item.item_resource = PurchasableItemList.spell_list[item]
			instanciated_item.get_child(0).get_node("button").connect("pressed", _buy_item.bind(instanciated_item))
			spell_h_box_container.add_child(instanciated_item)


func _buy_item(object_being_purchase: Control):
	if object_being_purchase.item_resource.price <= Globals.money:
		Globals.money -= object_being_purchase.item_resource.price
		if object_being_purchase.item_resource.item_type == "Objects":
			world_scene.get_node("Player")._start_bulding_phase(object_being_purchase.item_resource.item_scene)
		else:
			if Globals.spell_inventory_list.size() != 2:
				Globals.spell_inventory_list.push_front(object_being_purchase.item_resource)
			else:
				#faça uma magia ser escolhida parecer ser retirada
				#tirar uma das magias do invéntario
				#adiciona a magia comprada ao invéntario
				pass
		get_parent().visible = false
		Globals.game_paused = false
		if PurchasableItemList.games_list.size() != 0:
			for item in PurchasableItemList.games_list.size():
				games_h_box_container.get_child(item- 1).queue_free()
		if PurchasableItemList.decoration_list.size() != 0:
			for item in PurchasableItemList.decoration_list.size():
				decoration_h_box_container.get_child(item- 1).queue_free()
		if PurchasableItemList.spell_list.size() != 0:
			for item in PurchasableItemList.spell_list.size():
				spell_h_box_container.get_child(item- 1).queue_free()
		
