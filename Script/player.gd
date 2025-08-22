extends CharacterBody3D

@onready var camera: Camera3D = $Pivot/Camera
@onready var pivot: Node3D = $Pivot
@onready var ray_interection: RayCast3D = $Pivot/Camera/RayInterection
@onready var ray_builder_1: RayCast3D = $Pivot/Camera/RayBuilder1
@onready var ray_builder_2: RayCast3D = $Pivot/Camera/RayBuilder2
@onready var ray_builder: RayCast3D
@onready var call_npc_area: Area3D = $"Call NPC Area"
@onready var play_game: Timer = $play_game
@onready var world_scene = $"../"
@onready var loading_suit = preload("res://Scenes/loading_suit.tscn")
@onready var ui = $"../HUD"
@onready var money = $"../HUD/money_box/Gold"

@onready var walk_1: AudioStreamPlayer3D = $Walk1
@onready var walk_2: AudioStreamPlayer3D = $Walk2

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

signal build_tutorial
signal slot_machine_tutorial

var object_sitting: InteractableObject


func _ready() -> void:
	if Globals.save_player_pos != Vector3():
		global_position = Globals.save_player_pos

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
	
	if is_on_floor() and velocity.length() > 0.2:
		if sin(t_bob * bob_freq) < -0.95:  
			if not walk_1.playing and not walk_2.playing:
				if randf() > 0.5:
					walk_1.play()
				else:
					walk_2.play()
					
	if ray_builder_2.is_colliding():
		ray_builder = ray_builder_2
	else: 
		ray_builder = ray_builder_1
	
	if !is_on_building_mode:
		if Input.is_action_just_pressed("e") and Globals.player_interacting == false:
			if world_scene.player_recon.player_inside:
				for item in world_scene.get_node("Walking_NPCs").get_children():
					var save_npcs_info : Array
					save_npcs_info.push_back(item.scene_file_path)
					save_npcs_info.push_back(item.global_position)
					save_npcs_info.push_back(item.get_index())
					save_npcs_info.push_back(item.money)
					Globals.save_npcs_pos.push_back(save_npcs_info)
				for item in 2:
					var node_to_get
					match item:
						0:
							node_to_get = world_scene.all_interactable_spots
						1:
							node_to_get = world_scene.all_non_interactable_objects
					for object in node_to_get.get_children():
						var save_object_info: Array
						save_object_info.push_back(object.scene_file_path)
						save_object_info.push_back(object.global_position)
						save_object_info.push_back(object.rotation)
						Globals.save_objects.push_back(save_object_info)
				var array_of_building_spot: Array
				for item in world_scene.get_node("All Build spots").get_children():
					array_of_building_spot.push_back(item.taken)
				Globals.save_build_spot.push_back(array_of_building_spot)
				Globals.save_player_pos = global_position
				loading_screen("fight_ring")
			elif ray_interection.get_collider() != null:
				_interact_object()
		
		elif Input.is_action_just_pressed("c") and \
		object_sitting != null:
			_call_npc_to_game()
			
		if Input.is_action_just_pressed("b") and TutorialManager.tutorials["movement"]:
			world_scene.get_node("Shop Menu").get_child(0)._show_shop_menu()
		
		if Input.is_action_just_pressed("f") and Globals.check_spell_available("Wheel of Fortune") and \
		Globals.fortuna_target != null:
			Globals.fortuna_target.spell_cast("Wheel of Fortune")
			ui.update_spell_slots()
			SpellSounds.feitiço_sfx.play()
			Globals.fortuna_sounds()
			Globals.fortuna_target.input_disappear()
			
		if Input.is_action_just_pressed("h") and ray_interection.get_collider() != null:
			_sell()
	else:
			
		if Input.is_action_just_pressed("rightclick") and is_on_building_mode:
			_build()
			
		if Input.is_action_just_pressed("h"):
			_cancel_build()
			
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
			if object_sitting is InteractableObject\
			  and choosen_NPC != null:
				choosen_NPC._get_called_to_play_game(object_sitting)
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
	world_scene.update_all_mesh.emit()
	if !TutorialManager.tutorials["build"]:
		build_tutorial.emit()
	object_rotation = Vector3.ZERO
	current_object_being_purchased = object_to_be_purchase
	var current_object_being_purchased_instantiate = current_object_being_purchased.instantiate()
	if current_object_being_purchased_instantiate is InteractableObject:
		current_object_being_purchased_instantiate = current_object_being_purchased_instantiate.get_node("Model").duplicate()
		current_object_being_purchased_instantiate.add_to_group("Ground_object")

	for item in current_object_being_purchased_instantiate.get_children():
		if item is Node3D or item is CollisionShape3D:
			pass
		else:
			item.queue_free()
	for item in current_object_being_purchased_instantiate.get_child(0).get_child(0).mesh.get_surface_count():
		current_object_being_purchased_instantiate.get_child(0).get_child(0).mesh.surface_get_material(item).next_pass = BUILD_SHADER
		current_object_being_purchased_instantiate.get_child(0).get_child(0).mesh.surface_get_material(item).next_pass.set_shader_parameter("active", true)
	var new_area3d = Area3D.new()
	new_area3d.name = "Area 3d"
	new_area3d.collision_layer = 4
	for item in current_object_being_purchased_instantiate.get_children():
		if item is CollisionShape3D:
			var instantiate_colission = item.duplicate()
			current_object_being_purchased_instantiate.get_child(item.get_index()).queue_free()
			new_area3d.add_child(instantiate_colission)
	current_object_being_purchased_instantiate.add_child(new_area3d)
	for item in current_object_being_purchased_instantiate.get_children():
		print(item)
		if item.get_script() != null and item.get_script().resource_path == "res://Script/build_spot.gd":
			item.queue_free()
	ray_builder_1.add_child(current_object_being_purchased_instantiate)
	ray_builder_1.get_child(0).position = ray_builder_1.position + Vector3(0,0,-3)
	is_on_building_mode = true
	
func _rotate_bulding_object(rotation_direction: int):
	object_rotation += Vector3(0,deg_to_rad(8),0) * rotation_direction
	
func _cancel_build():
	world_scene.update_all_mesh.emit()
	is_on_building_mode = false
	current_object_being_purchased = null
	Globals.money += Globals.save_money 
	ray_builder_1.get_child(0).queue_free()
	
func _build():
	if can_build == true:
		build_sfx()
		if !TutorialManager.tutorials["slot_machine1"]:
			slot_machine_tutorial.emit()
		world_scene.update_all_mesh.emit()
		var instantiate_object = current_object_being_purchased.instantiate()
		ray_builder.get_collider().get_parent().taken = true
		instantiate_object.rotation = ray_builder_1.get_child(0).rotation
		ray_builder_1.get_child(0).queue_free()
		if instantiate_object is InteractableObject:
			world_scene.get_node("NavigationRegion3D").get_node("All Interactable Spots").add_child(instantiate_object)
		else:
			world_scene.get_node("NavigationRegion3D").get_node("All non interactable objects").add_child(instantiate_object)
		if instantiate_object.scene_file_path == "res://Scenes/chandelier_.tscn":
			instantiate_object.global_position = ray_builder_1.get_child(0).global_position + Vector3(0, 1.5, 0)
		else:
			instantiate_object.global_position = ray_builder_1.get_child(0).global_position - Vector3(0, 1, 0)
		world_scene.get_node("NavigationRegion3D").bake_navigation_mesh()
		is_on_building_mode = false
		current_object_being_purchased = null
		can_build = false
		Globals.save_money = 0
		SaveScript.auto_save.emit()
		if instantiate_object.get_node_or_null("Sell_Satisfation Value") != null:
			Globals.satisfaction_level += instantiate_object.get_node("Sell_Satisfation Value").satisfaction_value

		var save_ray_builder_1_monetoring = ray_builder_1.get_collider()
		var save_ray_builder_2_monetoring = ray_builder_2.get_collider()
		if save_ray_builder_1_monetoring != null:
			save_ray_builder_1_monetoring.monitoring = false
		if save_ray_builder_2_monetoring != null:
			save_ray_builder_2_monetoring.monitoring = false
		await get_tree().create_timer(0.1).timeout
		if save_ray_builder_1_monetoring != null:
			save_ray_builder_1_monetoring.monitoring = true
		if save_ray_builder_2_monetoring != null:
			save_ray_builder_2_monetoring.monitoring = true
	
func _sell():
	CoinEarned.moedas_01.play()
	var object_inst = ray_interection.get_collider()
	if object_inst.get_parent() is InteractableObject:
		object_inst = object_inst.get_parent()
	if object_inst != null and object_inst.get_node_or_null("Sell_Satisfation Value") != null and Globals.game_paused == false:
		ray_builder.get_collider().get_parent().taken = false
		if ray_builder.get_collider().get_overlapping_bodies().is_empty() != true:
			for item in ray_builder.get_collider().get_overlapping_bodies():
				if item.get_parent() is InteractableObject:
					item = item.get_parent()
				if item.get_node_or_null("Sell_Satisfation Value") != null:
					Globals.money += item.get_node_or_null("Sell_Satisfation Value").sell_value
					Globals.satisfaction_level -= item.get_node("Sell_Satisfation Value").satisfaction_value
					item.queue_free()
		SaveScript.auto_save.emit()

func lock_model_into_build_spot():
	if ray_builder.get_collider() != null\
	and ray_builder.get_collider().get_name() == "Area build spot"\
	and ray_builder.get_collider().is_in_group(ray_builder_1.get_child(0).get_groups()[0])\
	and ray_builder_1.get_child(0).get_child(-1).has_overlapping_bodies() == false\
	and ray_builder.get_collider().get_parent().taken == false:
		if ray_builder_1.get_child(0).scene_file_path == "res://Scenes/chandelier_.tscn":
			ray_builder_1.get_child(0).global_position = ray_builder.get_collider().get_parent().global_position + Vector3(0, 0.5, 0)
		else:
			ray_builder_1.get_child(0).global_position = ray_builder.get_collider().get_parent().global_position - Vector3(0, 0.5, 0)
		ray_builder_1.get_child(0).rotation = ray_builder_1.get_child(0).rotation  + ray_builder.get_collider().get_parent().rotation
		can_build = true
		for item in ray_builder_1.get_child(0).get_child(0).get_child(0).mesh.get_surface_count():
			ray_builder_1.get_child(0).get_child(0).get_child(0).mesh.surface_get_material(item).next_pass.set_shader_parameter("outline_color", Color.GREEN)
		ray_builder_1.get_child(0).top_level = true
		ray_builder_1.get_child(0).rotation = object_rotation + ray_builder.get_collider().get_parent().rotation
	
	elif ray_builder.get_collider() != null \
	and ray_builder.get_collider().get_name() == "Area build spot"\
	and ray_builder.get_collider().is_in_group(ray_builder_1.get_child(0).get_groups()[0])\
	and ray_builder_1.get_child(0).get_child(-1).has_overlapping_bodies() == true:
		if ray_builder_1.get_child(0).scene_file_path == "res://Scenes/chandelier_.tscn":
			ray_builder_1.get_child(0).global_position = ray_builder.get_collider().get_parent().global_position + Vector3(0, 0.5, 0)
		else:
			ray_builder_1.get_child(0).global_position = ray_builder.get_collider().get_parent().global_position - Vector3(0, 0.5, 0)
		can_build = false
		for item in ray_builder_1.get_child(0).get_child(0).get_child(0).mesh.get_surface_count():
			ray_builder_1.get_child(0).get_child(0).get_child(0).mesh.surface_get_material(item).next_pass.set_shader_parameter("outline_color", Color.RED)
		ray_builder_1.get_child(0).top_level = true
		ray_builder_1.get_child(0).rotation = object_rotation + ray_builder.get_collider().get_parent().rotation
	
	elif ray_builder.get_collider() == null:
		ray_builder_1.get_child(0).position = ray_builder_1.position + Vector3(0,0,-3)
		can_build = false
		for item in ray_builder_1.get_child(0).get_child(0).get_child(0).mesh.get_surface_count():
			ray_builder_1.get_child(0).get_child(0).get_child(0).mesh.surface_get_material(item).next_pass.set_shader_parameter("outline_color", Color.RED)
		ray_builder_1.get_child(0).top_level = false
		ray_builder_1.get_child(0).rotation = ray_builder.rotation
		object_rotation = Vector3.ZERO
func build_sfx():
	var which = randi_range(1, 3)
	match which:
		1:
			BuildingSfx.construir_01.play()
		2:
			BuildingSfx.construir_02.play()
		3:
			BuildingSfx.construir_03.play()
	
