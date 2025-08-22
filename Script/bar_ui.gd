extends Control

@onready var drink_name: Label = $HBoxContainer/Selected_Drink/Drink_Box/Name
@onready var sprite: TextureRect = $HBoxContainer/Selected_Drink/Drink_Box/Sprite
@onready var description: Label = $HBoxContainer/Selected_Drink/Drink_Box/Description
@onready var buy_button: Button = $HBoxContainer/Selected_Drink/Buy_Button
@onready var gold: Label = $HBoxContainer/Selected_Drink/Gold
@onready var sip_potion: AudioStreamPlayer = $"../sipPotion"
@onready var select_potion: AudioStreamPlayer = $"../selectPotion"


var save_bar_reference: InteractableObject

var selected_drink: VBoxContainer

func show_bar_ui(bar_reference: InteractableObject):
	get_parent().visible = true
	save_bar_reference = bar_reference
	gold.text = "Gold:" + str(Globals.money)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func buy_drink():
	sip_potion.play()
	if selected_drink.drink_price <= Globals.money:
		Globals.money -= selected_drink.drink_price
		match selected_drink.drink_name:
			"Aqua Vitae":
				if Globals.aqua_vitae_timer.time_left <= 0:
					if Globals.money_lost > 0:
						Globals.money += round(Globals.money_lost/4)
					elif Globals.money_lost == 0:
						Globals.money += 50
					Globals.money_lost = -1
					Globals.aqua_vitae_timer.start(180)
				else:
					print("Aqua Vitae already active")
			"Aqua Fortis":
				Globals.aqua_fortis_active = true
				Globals.aqua_regia_timer.stop()
				Globals.aqua_philosophorum_timer.stop()
			"Aqua Regia":
				Globals.aqua_fortis_active = false
				Globals.aqua_regia_timer.start(180)
				Globals.aqua_philosophorum_timer.stop()
			"Aqua Philosophorum":
				Globals.aqua_fortis_active = false
				Globals.aqua_regia_timer.stop()
				Globals.aqua_philosophorum_timer.start(180)
		clear_selection()
		
	else:
		print("Potion not affordable")

func select_drink(chosen_drink):
	select_potion.play()
	selected_drink = chosen_drink
	drink_name.text = selected_drink.drink_name
	sprite.texture = chosen_drink.drink_image
	description.text = chosen_drink.description
	buy_button.text = "Buy " + chosen_drink.drink_name + " for " + str(chosen_drink.drink_price) + " Gold"
	if !sprite.visible:
		sprite.visible = true
		description.visible = true
		buy_button.visible = true

func clear_selection():
	get_parent().visible = false
	save_bar_reference._cancel_interact_Bar(get_parent().get_parent().get_node("Player"))
	drink_name.text = "Select a potion to view description"
	sprite.visible = false
	description.visible = false
	buy_button.visible = false

func _on_buy_button_pressed() -> void:
	buy_drink()
