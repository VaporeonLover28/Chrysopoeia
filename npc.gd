extends CharacterBody3D; class_name NPC;

@onready var nav: NavigationAgent3D = $nav
@onready var idle: Timer = $idle
@onready var targeted_interactable_object_timer: Timer = $"Targeted Interactable Object"
@onready var leave_interaction: Timer = $"Leave Interaction"
@onready var all_interactable_spots: Node = $"../NavigationRegion3D/All Interactable Spots"
var is_on_interaction : bool = false
var is_going_to_interaction : bool = false
var targeted_position_is = null
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
	
	if is_going_to_interaction == false:
		_walk_to(targeted_position_vector)
	
	if targeted_position_is == InteractableObject:
		_go_to_interactable_object()
	
	move_and_slide()
	
func _walk_to(target_positon : Vector3):
	nav.set_target_position(target_positon)
	
func _go_to_interactable_object():
	is_going_to_interaction = true
	if nav.distance_to_target() == 0:
		targeted_position_is._interact([self])
		leave_interaction.start()
		is_going_to_interaction = false
		print("estou jogando")
	while targeted_position_is.see_if_npc_can_sit() == true:
		return
	if targeted_position_is.see_if_npc_can_sit() == true:
		targeted_position_is = all_interactable_spots.get_children().pick_random()
		targeted_position_vector = \
		 targeted_position_is.get_node("Sit positions").get_children().pick_random().global_position
	else:
		idle.start()
		_walk_to_random(-10, 10, -15.5, 1.5)
		is_going_to_interaction = false
	
	
func chose_interactable_object():
	targeted_position_is = all_interactable_spots.get_children().pick_random()
	if targeted_position_is is GambleSpot:
		targeted_position_vector = \
		 targeted_position_is.get_node("Sit positions").get_children().pick_random().global_position
	else:
		targeted_position_vector = targeted_position_is.global_position

func _walk_to_random(min_x, max_x, min_z, max_z):
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
	print("tentei sair")
	if targeted_position_is is GambleSpot:
		targeted_position_is._cancel_interact_GambleSpot(self)
	is_on_interaction = false
	idle.start()
	targeted_interactable_object_timer.start()
	_walk_to_random(-10, 10, -15.5, 1.5)
