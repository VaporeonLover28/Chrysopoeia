extends CharacterBody3D

@onready var camera: Camera3D = $Pivot/Camera
@onready var pivot: Node3D = $Pivot
@onready var ray_interection: RayCast3D = $Pivot/Camera/RayInterection
@onready var ray_builder: RayCast3D = $Pivot/Camera/RayBuilder
@onready var play_game: Timer = $play_game
@onready var world_scene = $"../"
const BUILD_SHADER = preload("res://build_material.tres")

@export var mouse_sensitivity: float = 0.005
@export var speed : float = 4.0
#run speed is speed * value, not the value
@export var run_speed : float = 1
#varibles relacionated with buying on the shop
var is_on_building_mode: bool = false
var current_object_being_purchase: Resource
var can_build : bool
var object_rotation: Vector3

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
	
	if Input.is_action_just_pressed("e") and Globals.player_interacting == false and is_on_building_mode == false:
		_interact_object()
		
	elif Input.is_action_just_pressed("e") and Globals.player_interacting == true and is_on_building_mode == false:
		_cancel_interaction()
		
	if Input.is_action_just_pressed("b") and Globals.player_interacting == false and is_on_building_mode == false:
		_start_bulding_phase("res://gamble_spot.tscn")
		await get_tree().create_timer(0.1).timeout
	
	if Input.is_action_just_pressed("b") and is_on_building_mode == true:
		_build()
		
	if Input.is_action_pressed("q") and is_on_building_mode == true:
		_rotate_bulding_object(-1)
		
	if Input.is_action_pressed("e") and is_on_building_mode == true:
		_rotate_bulding_object(1)
		
	if is_on_building_mode == true:
		lock_model_into_build_spot()
	
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
		#is breaking the game beacuse removes the player reference
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
	object_rotation = Vector3.ZERO
	current_object_being_purchase = load(object_to_be_purchase)
	var current_object_being_purchase_instantiate = current_object_being_purchase.instantiate()
	var instantiate_model = \
	current_object_being_purchase_instantiate.get_node("Model").duplicate()
	var new_instance_mesh = MeshInstance3D.new()
	new_instance_mesh.mesh = instantiate_model.get_node("MeshInstance3D").mesh.duplicate()
	instantiate_model.get_node("MeshInstance3D").queue_free()
	new_instance_mesh.mesh.material = BUILD_SHADER
	new_instance_mesh.mesh.material.set_shader_parameter("bluemulti", 0.0)
	instantiate_model.add_child(new_instance_mesh)
	var instantiate_colission = instantiate_model.get_node("CollisionShape3D").duplicate()
	instantiate_model.get_node("CollisionShape3D").queue_free()
	var new_area3d = Area3D.new()
	new_area3d.collision_layer = 2
	instantiate_model.add_child(new_area3d)
	instantiate_model.get_child(-1).add_child(instantiate_colission)
	instantiate_model.position = ray_builder.position + Vector3(0,0,-3)
	ray_builder.add_child(instantiate_model)
	current_object_being_purchase_instantiate.queue_free()
	is_on_building_mode = true
	
	
func _rotate_bulding_object(rotation_direction: int):
	object_rotation += Vector3(0,8,0) * rotation_direction
	
func _cancel_build():
	is_on_building_mode = false
	current_object_being_purchase = null
	ray_builder.get_child(0).queue_free()
	
func _build():
	if can_build == true:
		var instantiate_object = current_object_being_purchase.instantiate()
		instantiate_object.global_position = ray_builder.get_child(0).global_position
		instantiate_object.rotation = ray_builder.get_child(0).rotation
		ray_builder.get_child(0).queue_free()
		world_scene.get_node("NavigationRegion3D").get_node("All Interactable Spots").add_child(instantiate_object)
		world_scene.get_node("NavigationRegion3D").bake_navigation_mesh()
		is_on_building_mode = false
		current_object_being_purchase = null
		can_build = false
	
func _sell():
	var object_chosen = ray_interection.get_collider()
	if object_chosen != null and object_chosen.get_parent().get_parent() is InteractableObject and Globals.game_paused == false:
		object_chosen.queue_free()
		
func lock_model_into_build_spot():
	if ray_builder.get_collider() != null \
	and ray_builder.get_collider().get_name() == "Area build spot"\
	and ray_builder.get_collider().is_in_group(ray_builder.get_node("Model").get_groups()[0])\
	and ray_builder.get_node("Model").get_child(-1).has_overlapping_bodies() == false:
		ray_builder.get_child(0).global_position = ray_builder.get_collider().get_parent().global_position
		ray_builder.get_child(0).rotation = ray_builder.get_child(0).rotation  + ray_builder.get_collider().get_parent().rotation
		can_build = true
		ray_builder.get_node("Model").get_child(0).mesh.material.set_shader_parameter("greenmulti", 1.0)
		ray_builder.get_node("Model").get_child(0).mesh.material.set_shader_parameter("redmulti", 0.0)
		ray_builder.get_node("Model").top_level = true
		ray_builder.get_node("Model").rotation = object_rotation + ray_builder.get_collider().get_parent().rotation
		
		
	elif ray_builder.get_collider() != null \
	and ray_builder.get_collider().get_name() == "Area build spot"\
	and ray_builder.get_collider().is_in_group(ray_builder.get_node("Model").get_groups()[0])\
	and ray_builder.get_node("Model").get_child(-1).has_overlapping_bodies() == true:
		ray_builder.get_child(0).global_position = ray_builder.get_collider().get_parent().global_position
		can_build = false
		ray_builder.get_node("Model").get_child(0).mesh.material.set_shader_parameter("redmulti", 1.0)
		ray_builder.get_node("Model").get_child(0).mesh.material.set_shader_parameter("greenmulti", 0.0)
		ray_builder.get_node("Model").top_level = true
		ray_builder.get_node("Model").rotation = object_rotation + ray_builder.get_collider().get_parent().rotation
	
	elif ray_builder.get_collider() == null:
		ray_builder.get_child(0).position = ray_builder.position + Vector3(0,0,-3)
		can_build = false
		ray_builder.get_node("Model").get_child(0).mesh.material.set_shader_parameter("redmulti", 1.0)
		ray_builder.get_node("Model").get_child(0).mesh.material.set_shader_parameter("greenmulti", 0.0)
		ray_builder.get_node("Model").top_level = false
		ray_builder.get_node("Model").rotation = ray_builder.rotation
		object_rotation = Vector3.ZERO
