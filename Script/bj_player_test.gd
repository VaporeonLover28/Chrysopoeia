extends CharacterBody3D

@onready var camera: Camera3D = $Pivot/Camera
@onready var pivot: Node3D = $Pivot
@onready var ray_interection: RayCast3D = $Pivot/Camera/RayInterection
@onready var ui: Control = $"../CanvasLayer/Blackjack_UI_test"
@onready var game: Node3D = $".."

@export var ZOOM_SPEED : int = 2
@export var mouse_sensitivity: float = 0.005
@export var speed : float = 4.0

var zooming : bool = false

var dealer_hand : Array = []
var dealer_hand_value : int = 0
var aces_in_hand : int

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#transform = Globals.player_transform_storage[0]
	#pivot.transform = Globals.player_transform_storage[1]
	#camera.transform = Globals.player_transform_storage[2]
	#camera.current = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		ui._slide()
	
	if Input.is_action_just_pressed("r") and !game.round_started:
		game.call_player()
	
	if Input.is_action_just_pressed("f"):
		if game.distributed_cards:
			game.pass_turn()
			ui.f.modulate = Color.DIM_GRAY
		else:
			game.start_game()
	
	if Input.is_action_just_pressed("q") and game.dealer_can_hit:
		game.dealer_hit()
	
	if Input.is_action_just_pressed("e") and game.dealer_can_stand:
		game.dealer_stand()
	
	move_and_slide()

func calculate_hand_value():
	var value_bank = 0
	aces_in_hand = 0
	
	for card in dealer_hand:
		match card.value:
			"A":
				value_bank += 11
				aces_in_hand += 1
			"2", "3", "4", "5", "6", "7", "8", "9", "10":
				value_bank += int(card.value)
			"J", "Q", "K":
				value_bank += 10
	
	if value_bank > 21:
		if aces_in_hand > 0 and value_bank - 10 < 22:
			value_bank -= 10
		elif aces_in_hand > 1 and value_bank - 20 < 22 and value_bank - 10 > 22:
			value_bank -= 20
		elif aces_in_hand > 1 and value_bank - 20 < 22 and value_bank - 10 < 22:
			value_bank -= 10
		else:
			game.dealer_bust()
	
	if value_bank == 21 and dealer_hand.size() == 2 and aces_in_hand == 1:
		game.dealer_blackjack()
	
	dealer_hand_value = value_bank
	update_gc_label()

func update_gc_label():
	game.gc_labels[6].text = "Dealer\nValue: " + str(dealer_hand_value) + "\nHand:\n"
	for cards in dealer_hand:
		game.gc_labels[6].text += str(cards.rank) + " of " + str(cards.suit) + ",\n"

func _unhandled_input(event): #event representa o evento do input
	#caso o jogo não esteja pausado
	if !Globals.game_paused:
		#se o jogador segurar o botão direito do mouse
		if Input.is_action_pressed("rightclick") and !zooming:
			camera.zoom_anim()
		elif Input.is_action_pressed("rightclick") and zooming:
			pass
		else:
			camera.zoom_out_anim()
			
		if event is InputEventMouseMotion: # se o jogador mover o mouse(prendemos ele na tela)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if event is InputEventMouseMotion:
			if !Globals.player_interacting:
				pivot.rotate_y(-event.relative.x * mouse_sensitivity)
				camera.rotate_x(-event.relative.y * mouse_sensitivity)
				camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(70))
				pivot.rotation.y = clamp(pivot.rotation.y, deg_to_rad(-45), deg_to_rad(45))
	
	if event.is_action_pressed("esc"):
		if !Globals.game_paused:#se ele apertar esc(soltamos o mouse)
			Globals.game_paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else: 
			Globals.game_paused = false
