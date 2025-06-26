extends CharacterBody3D

@onready var camera: Camera3D = $Pivot/Camera
@onready var pivot: Node3D = $Pivot
@onready var ray_interection: RayCast3D = $Pivot/Camera/RayInterection
@onready var play_game: Timer = $play_game
@onready var world_scene = $"../"

@export var mouse_sensitivity: float = 0.005
@export var speed : float = 4.0
#run speed is speed * value, not the value
@export var run_speed : float = 1
#varibles relacionated with buying on the shop
var is_on_building_mode: bool = false
var current_object_being_purchase: Resource

#headbob vars
@export var bob_freq : float = 2
@export var bob_amp : float = 0.08
var t_bob : float = 0.0

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

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and Globals.game_paused == false:
		velocity += get_gravity() * delta
	
	if Input.is_action_pressed("shift") and Globals.game_paused == false:
		run_speed = 1.5
	else:
		run_speed = 1
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input := Input.get_vector("a", "d", "w", "s")
	var direction = (pivot.transform.basis * Vector3(input.x, 0, input.y)).normalized()
	if direction and Globals.game_paused == false:
		if Globals.player_interacting == false:
			velocity.x = direction.x * speed * run_speed
			velocity.z = direction.z * speed * run_speed
	elif !direction and Globals.game_paused == false:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	else:
		velocity = Vector3.ZERO
	
	#headbob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob) + Vector3(0, 0.5, 0)
	
	if Input.is_action_just_pressed("e") and Globals.player_interacting == false:
		_interact_object()
		
	elif Input.is_action_just_pressed("e") and Globals.player_interacting == true:
		_cancel_interaction()
	
	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * bob_freq) * bob_amp
	pos.x = cos(time * bob_freq / 2) * bob_amp
	return pos

func _interact_object():
	var object_chosen = ray_interection.get_collider()
	if object_chosen != null and object_chosen.get_parent() is InteractableObject and Globals.game_paused == false:
		object_chosen.get_parent()._interact([self])
		_play_blackjack()

func _cancel_interaction():
	Globals.player_interacting = false
	camera.current = true

func _play_blackjack():
	Globals.player_transform_storage.push_back(transform)
	Globals.player_transform_storage.push_back(pivot.transform)
	play_game.start()

func _on_play_game_timeout() -> void:
	Globals.player_transform_storage.push_back(camera.transform)
	get_tree().change_scene_to_file("res://blackjack_test_2.tscn")
	
func _start_bulding_phase(object_to_be_purchase: String):
	is_on_building_mode = true
	current_object_being_purchase = load(object_to_be_purchase)
	var instantiate_model = \
	current_object_being_purchase.get_node("model").get_child(0).instantiate()
	instantiate_model.position =  ray_interection.position - Vector3(0,0,-3)
	ray_interection.add_child(instantiate_model)
	
func _rotate_bulding_object(rotation_direction: int):
	ray_interection.get_child(0).rotate_x(8 * rotation_direction)
	
func _cancel_build():
	pass
	
func _build():
	var instantiate_object = current_object_being_purchase.instantiate()
	instantiate_object.global_position = ray_interection.position - Vector3(0,0,-3)
	instantiate_object.rotation = ray_interection.get_child(0).rotation
	ray_interection.get_child(0).queue_free()
	world_scene.add_child(instantiate_object)
