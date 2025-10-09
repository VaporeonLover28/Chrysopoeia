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
@onready var bg = $"../bg"
@onready var ring_door = $"../../NavigationRegion3D/cassino/door4"
@onready var bar: Node3D = $"../../NavigationRegion3D/All Interactable Spots/Bar"

var opened := false
var tween : Tween

signal wait_for_spell_change

func _ready() -> void:
	$Margin.position = Vector2(135, 64)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc") and get_parent().offset.y < 500 or \
	Input.is_action_just_pressed("b") and get_parent().offset.y < 500:
		hide_shop_menu()

func show_shop_menu():
	if Globals.player_interacting == false and Globals.game_paused == false \
	and get_parent().offset.y > 600:
		Globals.game_paused = true
		spell_option_box_container.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

		if tween:
			tween.kill()
		
		tween = create_tween()
		tween.set_trans(Tween.TRANS_QUART)
		tween.set_ease(Tween.EASE_OUT)
		tween.set_parallel(true)
		tween.tween_property(get_parent(), "offset", Vector2.ZERO, 0.75)
		tween.tween_callback(func():bg.play("open"))
		tween.tween_callback(func():
			await get_tree().create_timer(0.1).timeout
			opened = true
			visible = true
			money_label.text = "Money: " + str(Globals.money)
			for tab in shop_tabs.get_children():
				if tab.visible:
					for item in tab.get_child(0).get_child(0).get_children():
						item.update())
		
		if !TutorialManager.tutorials["open_shop"]:
			world_scene.shop_tutorial.emit()
	
func hide_shop_menu():
	opened = false
	Globals.game_paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_callback(func():visible = false)
	tween.tween_property(get_parent(), "offset", Vector2(0, 665), 0.5)
	tween.tween_callback(func():bg.play_backwards("open"))
	tween.tween_callback(func():opened = false)

func buy_item(object):
	if object.price <= Globals.money:
		if object.name == "Bar":
			Globals.bar_unlock = true
			bar.bought_bar.emit()
		elif object.name == "Chipped Key":
			Globals.ring_unlock = true
			ring_door.bought_ring_key.emit()
		else:
			if object.item_type == "Objects":
				world_scene.get_node("Player").start_bulding_phase(object.item_scene)
			##object.item_type == "Spells"
			else:
				if Globals.spell_inventory_list.size() < 2:
					Globals.spell_inventory_list.push_front(object)
				else:
					spell_slot1.texture = Globals.spell_inventory_list[0].item_sprite
					spell_slot1.get_parent().connect("pressed", _choose_spell_to_change.bind(Globals.spell_inventory_list[0]))
					spell_slot2.texture = Globals.spell_inventory_list[1].item_sprite
					spell_slot2.get_parent().connect("pressed", _choose_spell_to_change.bind(Globals.spell_inventory_list[1]))
					shop_tabs.visible = false
					spell_option_box_container.visible = true
					await wait_for_spell_change
					Globals.spell_inventory_list.push_front(object)
		Globals.money -= object.price
		CoinEarned.moedas_03.play()
		Globals.save_money += object.price
		hide_shop_menu()

func _choose_spell_to_change(spell_choosen: PurchasableItemResource):
	var spell_to_remove = Globals.spell_inventory_list.find(spell_choosen)
	Globals.spell_inventory_list.remove_at(spell_to_remove)
	wait_for_spell_change.emit()

func _on_quit_button_pressed() -> void:
	hide_shop_menu()

func _on_shop_tabs_tab_changed(tab: int) -> void:
	var on_screen_items = shop_tabs.get_child(tab).get_child(0).get_child(0).get_children()
	for item in on_screen_items:
		item.update()
