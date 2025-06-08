extends CharacterBody3D; class_name NPC;

@onready var nav: NavigationAgent3D = $nav
@onready var idle: Timer = $idle
@onready var targeted_interactable_object_timer: Timer = $"Targeted Interactable Object Timer"
@onready var leave_interaction: Timer = $"Leave Interaction"
@onready var all_interactable_spots: Node = $"../NavigationRegion3D/All Interactable Spots"
var is_on_interaction : bool = false
var is_going_to_interaction : bool = false
var targeted_position_is_object = null
var targeted_sitting_position : int = 20
var targeted_position_vector = Vector3(0,0,0)

func _ready() -> void:
	await get_tree().create_timer(randf())
	idle.start()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += 9.8 * delta
	
	var destino = nav.get_next_path_position()
	var local_destino = destino - global_position
	var dir = local_destino.normalized()
	velocity = dir * 2
	
	if is_on_interaction == false :
		_walk_to(targeted_position_vector)
	
	if targeted_position_is_object is InteractableObject and is_on_interaction == false:
		_go_to_interactable_object()
		
	if nav.is_target_reachable() == false:
		_walk_to_random(-10, 10, -15.5, 1.5)
	
	move_and_slide()
	
func _walk_to(target_positon : Vector3):
	nav.set_target_position(target_positon)
	
func _go_to_interactable_object():
	is_going_to_interaction = true
	if nav.is_navigation_finished() == true:
		targeted_sitting_position = 20
		is_going_to_interaction = false
		is_on_interaction = true
		targeted_position_is_object._interact([self])
		leave_interaction.start()
		print("estou jogando")
		return
	if targeted_position_is_object._SICSOC(targeted_sitting_position) == true:
		return
	else:
		if targeted_position_is_object._ASAT() == false:
			var random_choice_of_chair = randi_range(0, targeted_position_is_object.get_child_count() - 1)
			targeted_position_vector = \
			targeted_position_is_object.get_node("Sit positions").get_child(random_choice_of_chair).global_position
			targeted_sitting_position = random_choice_of_chair
		else:
			idle.start()
			_walk_to_random(-10, 10, -15.5, 1.5)
			is_going_to_interaction = false
	
	
func chose_interactable_object(): 
	idle.stop()
	targeted_position_is_object = all_interactable_spots.get_children().pick_random()
	if targeted_position_is_object is GambleSpot:
		var random_choice_of_chair = randi_range(0, targeted_position_is_object.get_child_count() - 1)
		targeted_position_vector = \
		targeted_position_is_object.get_node("Sit positions").get_child(random_choice_of_chair).global_position
		targeted_sitting_position = random_choice_of_chair
		print(random_choice_of_chair)
	else:
		targeted_position_vector = targeted_position_is_object.global_position

func _walk_to_random(min_x, max_x, min_z, max_z):
	targeted_position_is_object = null
	var random_positon := Vector3.ZERO
	random_positon.x = randf_range(min_x, max_x)
	random_positon.z = randf_range(min_z, max_z)
	targeted_position_vector = random_positon

func _on_nav_navigation_finished() -> void:
	if is_going_to_interaction == false and is_on_interaction == false:
		idle.start()

func _on_idle_timeout() -> void:
	_walk_to_random(-10, 10, -15.5, 1.5)
	
func _leave_interaction():
	if targeted_position_is_object is GambleSpot:
		targeted_position_is_object._cancel_interact_GambleSpot(self)
	is_on_interaction = false
	idle.start()
	targeted_interactable_object_timer.start()
	_walk_to_random(-10, 10, -15.5, 1.5)
