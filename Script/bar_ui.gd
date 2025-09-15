extends Control

@onready var drink_name: Label = $MarginContainer/HBoxContainer/Selected_Drink/Drink_Box/Name
@onready var sprite: TextureRect = $MarginContainer/HBoxContainer/Selected_Drink/Drink_Box/Sprite
@onready var description: Label = $MarginContainer/HBoxContainer/Selected_Drink/Drink_Box/Description
@onready var buy_button: Button = $MarginContainer/HBoxContainer/Selected_Drink/Buy_Button
@onready var gold: Label = $MarginContainer/HBoxContainer/Selected_Drink/Gold
@onready var sip_potion: AudioStreamPlayer = $"../sipPotion"
@onready var select_potion: AudioStreamPlayer = $"../selectPotion"

var player_ref
var save_bar_reference: InteractableObject
var selected_drink: VBoxContainer
var tween: Tween

func show_bar_ui(bar_reference: InteractableObject, player):
	player_ref = player
	save_bar_reference = bar_reference
	gold.text = "Gold:" + str(Globals.money)
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_parallel(true)
	tween.tween_property(get_parent(), "offset", Vector2(0, 0), 0.5)
	tween.tween_callback(func(): Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE))

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
				#else:
					#print("Aqua Vitae already active")
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
		
		# Update gold display after purchase
		gold.text = "Gold:" + str(Globals.money)
		clear_selection()
	#else:
		#print("Potion not affordable")

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
	player_ref.can_move = true
	Globals.player_interacting = false
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_parallel(true)
	tween.tween_property(get_parent(), "offset", Vector2(0, 270), 0.5)
	tween.tween_callback(_on_clear_selection_complete)

func _on_clear_selection_complete():
	# Reset UI elements
	drink_name.text = "Select a potion to view description"
	sprite.visible = false
	description.visible = false
	buy_button.visible = false
	
	# Only cancel interaction if we have a valid reference
	if save_bar_reference:
		# Use the correct method name and pass empty array as expected
		save_bar_reference._cancel_interact([])
	
	# Optional: Recapture mouse if needed for gameplay
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_buy_button_pressed() -> void:
	buy_drink()

# Add this function to handle manual closing without buying
func _input(event):
	if event.is_action_pressed("e") and get_parent().offset.y == 0:
		clear_selection()
