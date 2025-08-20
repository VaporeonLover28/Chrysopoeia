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
@onready var bg = $"../bg"

signal wait_for_spell_change
signal update_hud
signal update_shop_contents(added_itens: Array, removed_itens: Array)

var tween : Tween

#func _ready() -> void:
	#get_parent().visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc") and get_parent().visible or \
	Input.is_action_just_pressed("b") and get_parent().visible:
		hide_shop_menu()

func _show_shop_menu():
	print(shop_tabs.theme)
	get_parent().visible = true
	self.visible = false
	Globals.game_paused = true
	#shop_tabs.visible = true
	spell_option_box_container.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(get_parent(), "offset", Vector2.ZERO, 0.75)
	tween.tween_interval(0.75)
	tween.tween_callback(func():bg.play("open"))
	tween.tween_interval(0.75)
	tween.tween_callback(func():visible = true)
	
	money_label.text = "Money: " + str(Globals.money)
			
	
func hide_shop_menu():
	get_parent().visible = false
	Globals.game_paused = false
		

func _buy_item(object_being_purchased: Control):
	if object_being_purchased.item_resource.price <= Globals.money:
		if object_being_purchased.item_resource.item_type == "Objects" or \
		(object_being_purchased.item_resource.name == "Chipped Key"):
			if object_being_purchased.item_resource.name == "Chipped Key":
				#Globals.money -= object_being_purchased.item_resource.price
				Globals.ring_unlock = true
				ring_door.bought_ring_key.emit()
			else:
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
			if Globals.spell_inventory_list.size() < 2:
				#Globals.money -= object_being_purchased.item_resource.price
				Globals.spell_inventory_list.push_front(object_being_purchased.item_resource)
				update_hud.emit()
			else:
				spell_slot1.texture = Globals.spell_inventory_list[0].item_sprite
				spell_slot1.get_parent().connect("pressed", _choose_spell_to_change.bind(Globals.spell_inventory_list[0]))
				spell_slot2.texture = Globals.spell_inventory_list[1].item_sprite
				spell_slot2.get_parent().connect("pressed", _choose_spell_to_change.bind(Globals.spell_inventory_list[1]))
				shop_tabs.visible = false
				spell_option_box_container.visible = true
				await wait_for_spell_change
				Globals.spell_inventory_list.push_front(object_being_purchased.item_resource)
				update_hud.emit()
		Globals.money -= object_being_purchased.item_resource.price
		CoinEarned.moedas_03.play()
		Globals.save_money += object_being_purchased.item_resource.price
	hide_shop_menu()

func _choose_spell_to_change(spell_choosen: PurchasableItemResource):
	var spell_to_remove = Globals.spell_inventory_list.find(spell_choosen)
	Globals.spell_inventory_list.remove_at(spell_to_remove)
	wait_for_spell_change.emit()

func _on_quit_button_pressed() -> void:
	hide_shop_menu()

func _ready() -> void:
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

func _on_update_shop_contents(added_itens: Array[Array], removed_itens: Array[Array]) -> void:
	print("_on_update_shop_contents")
	if !added_itens[0].is_empty():
		_add_objects(games_h_box_container, added_itens[0])
	if !added_itens[1].is_empty():
		_add_objects(decoration_h_box_container, added_itens[1])
	if !removed_itens[2].is_empty():
		_add_objects(spell_h_box_container, added_itens[2])
	if !removed_itens[0].is_empty():
		_remove_objects(games_h_box_container, removed_itens[0])
	if !removed_itens[1].is_empty():
		_remove_objects(decoration_h_box_container, removed_itens[1])
	if !removed_itens[2].is_empty():
		_remove_objects(spell_h_box_container, removed_itens[2])
	
func _remove_objects(area_of_shop: HBoxContainer, objects_to_be_removed: Array):
	for buyable_object in area_of_shop.get_children():
		for itens_to_be_removed in objects_to_be_removed:
			if buyable_object.item_resource == itens_to_be_removed:
				buyable_object.queue_free()
	
func _add_objects(area_of_shop: HBoxContainer, objects_to_be_added: Array):
	var counter : int = 0
	for item in objects_to_be_added.size():
		var instanciated_item = buyable_object.instantiate()
		instanciated_item.item_resource = objects_to_be_added[counter]
		instanciated_item.get_child(0).get_node("Button").connect("pressed", _buy_item.bind(instanciated_item))
		instanciated_item.position.x += 245 + (item * 245)
		area_of_shop.add_child(instanciated_item)
		counter += 1
	
