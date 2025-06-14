extends CharacterBody3D

@onready var camera: Camera3D = $Pivot/Camera
@onready var pivot: Node3D = $Pivot
@onready var ray_interection: RayCast3D = $Pivot/Camera/RayInterection

@export var mouse_sensitivity: float = 0.005
@export var speed : float = 4.0

#run speed is speed * value, not the value
@export var run_speed : float = 1

#headbob vars
@export var bob_freq : float = 2
@export var bob_amp : float = 0.08
var t_bob : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transform = Globals.player_transform_storage[0]
	pivot.transform = Globals.player_transform_storage[1]
	camera.transform = Globals.player_transform_storage[2]
	camera.current = true

func _process(delta: float) -> void:
	move_and_slide()

func _unhandled_input(event): #event representa o evento do input
	if event.is_action_pressed("esc"):
		if Globals.game_paused == false:#se ele apertar esc(soltamos o mouse)
			Globals.game_paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else: 
			Globals.game_paused = false
	
	if event is InputEventMouseMotion and Globals.game_paused == false: # se o jogador mover o mouse(prendemos ele na tela)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventMouseMotion and Globals.game_paused == false:
		if Globals.player_interacting == false:
			pivot.rotate_y(-event.relative.x * mouse_sensitivity)
			camera.rotate_x(-event.relative.y * mouse_sensitivity)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(70))
