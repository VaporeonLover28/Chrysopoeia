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

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#transform = Globals.player_transform_storage[0]
	#pivot.transform = Globals.player_transform_storage[1]
	#camera.transform = Globals.player_transform_storage[2]
	#camera.current = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		ui._slide()
	
	if Input.is_action_just_pressed("e"):
		if game.round_started == false:
			game.call_player()
	
	if Input.is_action_just_pressed("s"):
		game.shuffle_deck()
	
	if Input.is_action_just_pressed("f"):
		game.pass_turn()
	
	if Input.is_action_just_pressed("r"):
		game.restart_game()
	
	if Input.is_action_just_pressed("q"):
		game.quit_game()
	
	move_and_slide()

func _unhandled_input(event): #event representa o evento do input
	#caso o jogo não esteja pausado
	if Globals.game_paused == false:
		#se o jogador segurar o botão direito do mouse
		if Input.is_action_pressed("rightclick") and zooming == false:
			camera.zoom_anim()
		elif Input.is_action_pressed("rightclick") and zooming == true:
			pass
		else:
			camera.zoom_out_anim()
			
		if event is InputEventMouseMotion: # se o jogador mover o mouse(prendemos ele na tela)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if event is InputEventMouseMotion:
			if Globals.player_interacting == false:
				pivot.rotate_y(-event.relative.x * mouse_sensitivity)
				camera.rotate_x(-event.relative.y * mouse_sensitivity)
				camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(70))
				pivot.rotation.y = clamp(pivot.rotation.y, deg_to_rad(-45), deg_to_rad(45))
	
	if event.is_action_pressed("esc"):
		if Globals.game_paused == false:#se ele apertar esc(soltamos o mouse)
			Globals.game_paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else: 
			Globals.game_paused = false
