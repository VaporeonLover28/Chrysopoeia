extends CharacterBody3D; class_name NPC;

@onready var nav: NavigationAgent3D = $nav
@onready var idle: Timer = $idle
@onready var targeted_interactable_object_timer: Timer = $"Targeted Interactable Object"
@onready var leave_interaction: Timer = $"Leave Interaction"
@onready var all_interactable_spots: Node = $"../NavigationRegion3D/All Interactable Spots"
var is_on_interaction : bool = false
var targeted_interactable_object: InteractableObject = null

func _ready() -> void:
	await get_tree().create_timer(randf())
	idle.start()

func _process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += 9.8 * delta
	
	var destino = nav.get_next_path_position()
	var local_destino = destino - global_position
	var dir = local_destino.normalized()
	velocity = dir * 2
	move_and_slide()
	
func _walk_to(target_positon : Vector3):
	
	nav.set_target_position(target_positon)
	
func _go_to_interactable_object():
	#gets a random interactable_object
	if is_on_interaction == false:
		targeted_interactable_object = all_interactable_spots.get_children().pick_random()
		if targeted_interactable_object is GambleSpot:
			_walk_to(\
			targeted_interactable_object.get_node("Sit positions").get_children().pick_random().global_position)
		else:
			_walk_to(targeted_interactable_object.global_position)
		
		await nav.navigation_finished
		print("hum")
		targeted_interactable_object._interact([self])
		leave_interaction.start()
	

func _walk_to_random(min_x, max_x, min_z, max_z):
	var random_positon := Vector3.ZERO
	random_positon.x = randf_range(min_x, max_x)
	random_positon.z = randf_range(min_z, max_z)
	_walk_to(random_positon)

func _on_nav_navigation_finished() -> void:
	if is_on_interaction == false:
		idle.start()

func _on_idle_timeout() -> void:
	_walk_to_random(-10, 10, -15.5, 1.5)
	
func _leave_interaction():
	if is_on_interaction == false:
		if targeted_interactable_object is GambleSpot:
			targeted_interactable_object._cancel_interact_GambleSpot([self])
		is_on_interaction = false
		idle.start()
		targeted_interactable_object
		targeted_interactable_object = null
