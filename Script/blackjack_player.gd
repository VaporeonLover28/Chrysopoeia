extends CharacterBody3D

@onready var camera: Camera3D = $Pivot/Camera
@onready var pivot: Node3D = $Pivot
@onready var ray_interection: RayCast3D = $Pivot/Camera/RayInterection
@onready var ui: Control = $"../CanvasLayer/Blackjack_UI_test"
@onready var game: Node3D = $".."

@export var ZOOM_SPEED : int = 2
@export var mouse_sensitivity: float = 0.005
@export var speed : float = 4.0

var tween : Tween

var allowed_to_move := false

var zooming : bool = false

var dealer_hand : Array = []
var dealer_hand_value : int = 0
var aces_in_hand : int

func _process(delta: float) -> void:
	if allowed_to_move:
		#if Input.is_action_just_pressed("space"):
			#ui._slide()
		
		if Input.is_action_just_pressed("r") and !game.round_started:
			game.call_player()
		
		if Input.is_action_just_pressed("f") and game.whose_turn != -1:
			if game.distributed_cards and game.bets_on_table:
				game.pass_turn()
				ui.f.modulate = Color.DIM_GRAY
			elif !game.distributed_cards and game.bets_on_table:
				game.start_game()
				ui.f.modulate = Color.DIM_GRAY
			else:
				game.place_bets()
		
		if Input.is_action_just_pressed("e") and game.dealer_can_hit:
			game.dealer_hit()
		
		if Input.is_action_just_pressed("q") and game.dealer_can_stand:
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
	#update_gc_label()

#func update_gc_label():
	#game.gc_labels[6].text = "Dealer\nValue: " + str(dealer_hand_value) + "\nHand:\n"
	#for cards in dealer_hand:
		#game.gc_labels[6].text += str(cards.rank) + " of " + str(cards.suit) + ",\n"

func _unhandled_input(event): #event representa o evento do input
	#caso o jogo não esteja pausado
	if !Globals.game_paused and allowed_to_move:
		if event.is_action_pressed("tab"):
			game.spell_cast("Eye of Providence")
		
		if event.is_action_pressed("a"):
			game.spell_cast("Fool's Gold")
		
		if event.is_action_pressed("d"):
			game.spell_cast("Philosopher's Shard")
		
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

func intro_tweens():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "global_position", Vector3(0, 1, 0.854), 2)
	await get_tree().create_timer(2.5).timeout
	allowed_to_move = true
