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

var opened := false
var tween : Tween

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

func _on_quit_button_pressed() -> void:
	hide_shop_menu()

func _on_shop_tabs_tab_changed(tab: int) -> void:
	var on_screen_items = shop_tabs.get_child(tab).get_child(0).get_child(0).get_children()
	for item in on_screen_items:
		item.update()
