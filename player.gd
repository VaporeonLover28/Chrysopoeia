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
		velocity.x = direction.x * speed * run_speed
		velocity.z = direction.z * speed * run_speed
	elif !direction and Globals.game_paused == false:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	else:
		velocity = Vector3.ZERO
	
	#headbob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
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
		object_chosen.get_parent()._interact(self)

func _cancel_interaction():
	Globals.player_interacting = false
	camera.current = true
