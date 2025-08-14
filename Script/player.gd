extends CharacterBody3D

@onready var camera: Camera3D = $Pivot/Camera
@onready var pivot: Node3D = $Pivot
@onready var ray_interection: RayCast3D = $Pivot/Camera/RayInterection
@onready var ray_builder: RayCast3D = $Pivot/Camera/RayBuilder
@onready var call_npc_area: Area3D = $"Call NPC Area"
@onready var play_game: Timer = $play_game
@onready var world_scene = $"../"
@onready var loading_suit = preload("res://Scenes/loading_suit.tscn")
@onready var ui = $"../HUD"
@onready var money = $"../HUD/money_box/Gold"

const BUILD_SHADER = preload("res://build_material.tres")

@export var mouse_sensitivity: float = 0.005
@export var speed : float = 4.0
#run speed is speed * value, not the value
@export var run_speed : float = 1
var can_move := true
#varibles relacionated with buying on the shop
var is_on_building_mode: bool = false
var current_object_being_purchased: PackedScene
var can_build : bool
var object_rotation: Vector3

#headbob vars
@export var bob_freq : float = 2
@export var bob_amp : float = 0.08
var t_bob : float = 0.0

var tween : Tween

func _unhandled_input(event): #event representa o evento do input
	if event.is_action_pressed("esc"):
		if Globals.game_paused == false:#se ele apertar esc(soltamos o mouse)
			Globals.game_paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if can_move:
		if event is InputEventMouseMotion and Globals.game_paused == false and world_scene.get_node("Bar UI").visible == false: # se o jogador mover o mouse(prendemos ele na tela)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if event is InputEventMouseMotion and Globals.game_paused == false \
		and world_scene.get_node("Bar UI").visible == false and Globals.player_interacting == false:
				pivot.rotate_y(-event.relative.x * mouse_sensitivity)
				camera.rotate_x(-event.relative.y * mouse_sensitivity)
				camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(70))

func _physics_process(delta: float) -> void:
	money.text = "Gold: " + str(Globals.money)
	# Add the gravity.
	if not is_on_floor() and Globals.game_paused == false:
		velocity += get_gravity() * delta
	
	if Input.is_action_pressed("shift") and Globals.game_paused == false:
		run_speed = 1.5
	else:
		run_speed = 1
	
	if can_move:
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
	
	if !is_on_building_mode:
		if Input.is_action_just_pressed("e") and Globals.player_interacting == false:
			#print("oi")
			if world_scene.player_recon.player_inside:
				loading_screen("fight_ring")
			else:
				_interact_object()
		
		elif Input.is_action_just_pressed("c") and \
		ray_interection.get_collider().get_parent().get_node_or_null("Sit positions") != null:
			_call_npc_to_game()
			
		if Input.is_action_just_pressed("b") and Globals.player_interacting == false and\
		Globals.game_paused == false:
			world_scene.get_node("Shop Menu").get_child(0)._show_shop_menu()
		
		if Input.is_action_just_pressed("f") and Globals.check_spell_available("Wheel of Fortune") and \
		Globals.fortuna_target != null:
			Globals.fortuna_target.spell_cast("Wheel of Fortune")
			Globals.fortuna_target.input_disappear()
	else:
		if Input.is_action_just_pressed("rightclick"):
			_build()
			
		if Input.is_action_pressed("q"):
			_rotate_bulding_object(-1)
			
		if Input.is_action_pressed("e"):
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
	var object_inst = ray_interection.get_collider()
	if object_inst != null and object_inst.get_parent() is InteractableObject and Globals.game_paused == false:
		object_inst.get_parent()._interact([self])

func _cancel_interaction():
	Globals.player_interacting = false
	
func _call_npc_to_game():
	if world_scene.get_node("Walking_NPCs").get_child_count() > 0 and Globals.game_paused == false:
		call_npc_area.get_child(0).disabled = false
		await get_tree().create_timer(0.1).timeout
		var bodies_on_area = call_npc_area.get_overlapping_bodies().filter(_filter_NPC_in_area)
		if bodies_on_area.is_empty() == false:
			var choosen_NPC = bodies_on_area.pick_random()
			var object_inst = ray_interection.get_collider()
			if object_inst.get_parent() is InteractableObject\
			  and choosen_NPC != null:
				choosen_NPC._get_called_to_play_game(object_inst.get_parent())
		call_npc_area.get_child(0).disabled = true
		
func _filter_NPC_in_area(bodies):
	return bodies is NPC

func loading_screen(game):
	Globals.player_pos_save = global_position
	can_move = false
	var which_suit = randi_range(0, 3)
	var inst = loading_suit.instantiate()
	match which_suit:
		0:
			inst.text += "♠"
		1:
			inst.text += "♣"
		2:
			inst.text += "♥"
		3:
			inst.text += "♦"
	ui.add_child(inst)
	inst.rotation = 0
	inst.scale = Vector2(0.05, 0.05)
	inst.position = Vector2(531.0, 234.0)
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(inst, "scale", Vector2(1.0, 1.0), 1)
	tween.tween_interval(0.5)
	tween.set_ease(Tween.EASE_IN)
	tween.set_parallel(true)
	tween.tween_property(inst, "scale", Vector2(27.0, 27.0), 3)
	tween.tween_property(inst, "rotation_degrees", 90, 3)
	tween.tween_property(inst, "position", Vector2(628.0, 223.0), 3)
	tween.set_parallel(false)
	await get_tree().create_timer(4.5).timeout
	get_tree().change_scene_to_file("res://Scenes/" + game + ".tscn")

func _start_bulding_phase(object_to_be_purchase: PackedScene):
	object_rotation = Vector3.ZERO
	current_object_being_purchased = object_to_be_purchase
	var current_object_being_purchased_instantiate = current_object_being_purchased.instantiate()
	if current_object_being_purchased_instantiate is InteractableObject:
		current_object_being_purchased_instantiate = current_object_being_purchased_instantiate.get_node("Model").duplicate(true)
		current_object_being_purchased_instantiate.add_to_group("Ground_object")
	for item in current_object_being_purchased_instantiate.get_child(0).get_child(0).mesh.get_surface_count():
		current_object_being_purchased_instantiate.get_child(0).get_child(0).mesh.surface_get_material(item).next_pass = BUILD_SHADER
		current_object_being_purchased_instantiate.get_child(0).get_child(0).mesh.surface_get_material(item).next_pass.set_shader_parameter("active", true)
	var new_area3d = Area3D.new()
	new_area3d.name = "Area 3d"
	new_area3d.collision_layer = 2
	for item in current_object_being_purchased_instantiate.get_children():
		if item is CollisionShape3D:
			var instantiate_colission = item.duplicate()
			current_object_being_purchased_instantiate.get_child(item.get_index()).queue_free()
			new_area3d.add_child(instantiate_colission)
	current_object_being_purchased_instantiate.add_child(new_area3d)
	current_object_being_purchased_instantiate.position = ray_builder.position + Vector3(0,0,-3)
	print(current_object_being_purchased_instantiate)
	ray_builder.add_child(current_object_being_purchased_instantiate)
	print(ray_builder.get_child(0))
	is_on_building_mode = true
	
func _rotate_bulding_object(rotation_direction: int):
	object_rotation += Vector3(0,8,0) * rotation_direction
	
func _cancel_build():
	print("oi")
	is_on_building_mode = false
	current_object_being_purchased = null
	ray_builder.get_child(0).queue_free()
	
func _build():
	if can_build == true:
		print("oi")
		var instantiate_object = current_object_being_purchased.instantiate()
		instantiate_object.global_position = ray_builder.get_collider().get_parent().global_position - Vector3(0, 1, 0)
		instantiate_object.rotation = ray_builder.get_child(0).rotation
		ray_builder.get_child(0).queue_free()
		world_scene.get_node("NavigationRegion3D").get_node("All Interactable Spots").add_child(instantiate_object)
		world_scene.get_node("NavigationRegion3D").bake_navigation_mesh()
		is_on_building_mode = false
		current_object_being_purchased = null
		can_build = false
		SaveScript.auto_save.emit()
	
func _sell():
	var object_inst = ray_interection.get_collider()
	if object_inst != null and object_inst.get_parent().get_parent() is InteractableObject and Globals.game_paused == false:
		print("oi")
		object_inst.queue_free()

func lock_model_into_build_spot():
	print(ray_builder.get_child(0).get_groups())
	if ray_builder.get_collider() != null \
	and ray_builder.get_collider().get_name() == "Area build spot"\
	and ray_builder.get_collider().is_in_group(ray_builder.get_child(0).get_groups()[0])\
	and ray_builder.get_child(0).get_child(-1).has_overlapping_bodies() == false:
		ray_builder.get_child(0).global_position = ray_builder.get_collider().get_parent().global_position
		ray_builder.get_child(0).rotation = ray_builder.get_child(0).rotation  + ray_builder.get_collider().get_parent().rotation
		can_build = true
		for item in ray_builder.get_child(0).get_child(0).get_child(0).mesh.get_surface_count():
			ray_builder.get_child(0).get_child(0).get_child(0).mesh.surface_get_material(item).next_pass.set_shader_parameter("outline_color", Color.GREEN)
		ray_builder.get_child(0).top_level = true
		ray_builder.get_child(0).rotation = object_rotation + ray_builder.get_collider().get_parent().rotation
		
	elif ray_builder.get_collider() != null \
	and ray_builder.get_collider().get_name() == "Area build spot"\
	and ray_builder.get_collider().is_in_group(ray_builder.get_child(0).get_groups()[0])\
	and ray_builder.get_child(0).get_child(-1).has_overlapping_bodies() == true:
		ray_builder.get_child(0).global_position = ray_builder.get_collider().get_parent().global_position
		can_build = false
		for item in ray_builder.get_child(0).get_child(0).get_child(0).mesh.get_surface_count():
			ray_builder.get_child(0).get_child(0).get_child(0).mesh.surface_get_material(item).next_pass.set_shader_parameter("outline_color", Color.RED)
		ray_builder.get_child(0).top_level = true
		ray_builder.get_child(0).rotation = object_rotation + ray_builder.get_collider().get_parent().rotation
	
	elif ray_builder.get_collider() == null:
		ray_builder.get_child(0).position = ray_builder.position + Vector3(0,0,-3)
		can_build = false
		for item in ray_builder.get_child(0).get_child(0).get_child(0).mesh.get_surface_count():
			ray_builder.get_child(0).get_child(0).get_child(0).mesh.surface_get_material(item).next_pass.set_shader_parameter("outline_color", Color.RED)
		ray_builder.get_child(0).top_level = false
		ray_builder.get_child(0).rotation = ray_builder.rotation
		object_rotation = Vector3.ZERO
