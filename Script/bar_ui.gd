extends Control

@onready var aqua_vitae: Control = $"BoxContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer2/HBoxContainer/Aqua Vitae"
@onready var aqua_fortis: Control = $"BoxContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer2/HBoxContainer/Aqua Fortis"
@onready var aqua_regia: Control = $"BoxContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer2/HBoxContainer2/Aqua Regia"
@onready var aqua_philosophorum: Control = $"BoxContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer2/HBoxContainer2/Aqua Philosophorum"
@onready var aqua_vitae_button: TextureButton = $"BoxContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer2/HBoxContainer/Aqua Vitae/HBoxContainer/TextureButton"
@onready var aqua_fortis_button: TextureButton = $"BoxContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer2/HBoxContainer/Aqua Fortis/HBoxContainer/TextureButton"
@onready var aqua_regia_button: TextureButton = $"BoxContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer2/HBoxContainer2/Aqua Regia/HBoxContainer/TextureButton"
@onready var aqua_philosophorum_button: TextureButton = $"BoxContainer/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer2/HBoxContainer2/Aqua Philosophorum/HBoxContainer/TextureButton"

var save_bar_reference: InteractableObject

var selected_drink: Control

func _ready() -> void:
	get_parent().visible = false
	aqua_vitae_button.connect("pressed", _select_drink.bind(aqua_vitae))
	aqua_fortis_button.connect("pressed", _select_drink.bind(aqua_fortis))
	aqua_regia_button.connect("pressed", _select_drink.bind(aqua_regia))
	aqua_philosophorum_button.connect("pressed", _select_drink.bind(aqua_philosophorum))
	
func _show_bar_ui(bar_reference: InteractableObject):
	get_parent().visible = true
	save_bar_reference = bar_reference
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _buy_drink():
	var money_to_pay: int
	match selected_drink:
		aqua_vitae:
			money_to_pay = 25
		aqua_fortis:
			money_to_pay = 80
		aqua_regia:
			money_to_pay = 120
		aqua_philosophorum:
			money_to_pay = 100
	if money_to_pay <= Globals.money:
		match selected_drink:
			aqua_vitae:
				if Globals.aqua_vitae_timer.time_left <= 0:
					if Globals.money_lost > 0:
						Globals.money += round(Globals.money_lost/4)
					elif  Globals.money_lost == 0:
						Globals.money += 50
					Globals.money_lost = -1
					Globals.aqua_vitae_timer.start(180)
				else:
					print("não pode comprar")
			aqua_fortis:
				Globals.aqua_fortis_active = true
				Globals.aqua_regia_timer.stop()
				Globals.aqua_philosophorum_timer.stop()
			aqua_regia:
				Globals.aqua_fortis_active = false
				Globals.aqua_regia_timer.start(180)
				Globals.aqua_philosophorum_timer.stop()
			aqua_philosophorum:
				Globals.aqua_fortis_active = false
				Globals.aqua_regia_timer.stop()
				Globals.aqua_philosophorum_timer.start(180)
		get_parent().visible = false
		save_bar_reference._cancel_interact_Bar(save_bar_reference.sit_positions.save_player_ref)
		print(Globals.player_interacting)
	else:
		print("cannot pay")
				
func _select_drink(choosen_drink: Control):
	selected_drink = choosen_drink
	print(selected_drink)
