extends CharacterBody3D; class_name NPC;

@onready var nav: NavigationAgent3D = $nav
@onready var idle: Timer = $idle
@onready var targeted_interactable_object_timer: Timer = $"Targeted Interactable Object Timer"
@onready var leave_interaction: Timer = $"Leave Interaction"
@onready var interacatable_object_detection_area: Area3D = $"Interacatable object Detection Area"
@onready var all_interactable_spots: Node = $"../../NavigationRegion3D/All Interactable Spots"
@onready var world_scene: Node3D = $"../../"
@onready var get_away_timer: Timer = $"Get Away Timer"

@export var npc_name: String
@export var minimum_time_for_idle: float
@export var maximum_time_for_idle: float
#TIOT = Targeted Interactable Object Timer
@export var minimum_time_for_TIOT: float
@export var maximum_time_for_TIOT: float

@export var favorite_games: Array[String]
@export_range(0 , 100) var chance_to_choose_favorite_game : int

@export var minimum_money: int
@export var maximum_money: int

@onready var money : int = randi_range(minimum_money, maximum_money)

var is_on_interaction : bool = false
var is_going_to_interaction : bool = false
var targeted_position_is_object = null
var targeted_sitting_position : int = 20

func _ready() -> void:
	_walk_to(world_scene.get_node("Enter point for npc").position)
	targeted_interactable_object_timer.start(randf_range(minimum_time_for_TIOT, maximum_time_for_TIOT))
	print(money)

func _physics_process(delta: float) -> void:
	if Globals.game_paused == false:
		if not is_on_floor():
			velocity.y += 9.8 * delta
		var destino = nav.get_next_path_position()
		var local_destino = destino - global_position
		var dir = local_destino.normalized()
		velocity = dir * 2
			
		if is_instance_valid(targeted_position_is_object) == true and targeted_position_is_object is InteractableObject and is_on_interaction == false:
			_go_to_interactable_object()
		
			
		move_and_slide()

func _walk_to(target_positon : Vector3):
	nav.set_target_position(target_positon)
	
func _go_to_interactable_object():
	is_going_to_interaction = true
	if nav.is_navigation_finished() == true:
		is_going_to_interaction = false
		is_on_interaction = true
		targeted_position_is_object._interact([self])
		print("sit")
		leave_interaction.start()
		get_away_timer.stop()
		return
	if targeted_position_is_object.get_node_or_null("Sit positions") != null:
		if targeted_position_is_object.get_node("Sit positions")._SICSOC(targeted_sitting_position) == true:
			return
		else:
			if targeted_position_is_object.get_node("Sit positions")._ASAT() == false:
				var random_choice_of_chair = randi_range(0, targeted_position_is_object.get_node("Sit positions").get_child_count() - 1)
				_walk_to(targeted_position_is_object.get_node("Sit positions").get_child(random_choice_of_chair).global_position)
				targeted_sitting_position = random_choice_of_chair
			else:
				targeted_interactable_object_timer.start(randf_range(minimum_time_for_TIOT, maximum_time_for_TIOT))
				_walk_to_random(-5, 5, -5, 5)
				is_going_to_interaction = false
				targeted_position_is_object = null

func chose_interactable_object():
	print("chosed interactable object")
	if Globals.game_paused == false:
		idle.stop()
		interacatable_object_detection_area.get_child(0).disabled = false
		await get_tree().create_timer(0.5).timeout
		var bodies_on_area = interacatable_object_detection_area.get_overlapping_bodies().filter(_filter_interactable_object_in_area)
		if bodies_on_area.is_empty() == false:
			see_if_favorite_game_is_in_area(bodies_on_area)
			if favorite_games.is_empty() != true and randi_range(0 ,100) <= chance_to_choose_favorite_game and see_if_favorite_game_is_in_area(bodies_on_area) == true:
				bodies_on_area = bodies_on_area.filter(_filter_favorite_game)
			var choosen_intecractable_object = bodies_on_area.pick_random().get_parent()
			targeted_position_is_object = choosen_intecractable_object
			if targeted_position_is_object.get_node_or_null("Sit positions") != null:
				var random_choice_of_chair = randi_range(0, targeted_position_is_object.get_node("Sit positions").get_child_count() - 1)
				_walk_to(targeted_position_is_object.get_node("Sit positions").get_child(random_choice_of_chair).global_position)
				targeted_sitting_position = random_choice_of_chair
			else:
				_walk_to(targeted_position_is_object.global_position)
		interacatable_object_detection_area.get_child(0).disabled = true
		
func _filter_interactable_object_in_area(bodies):
	return bodies.get_parent() is InteractableObject
	
func _filter_favorite_game(bodies):
	for item in favorite_games:
		if bodies.get_parent().object_name == item:
			return true
	return false
	
func see_if_favorite_game_is_in_area(array_of_bodies: Array):
	for bodies in array_of_bodies:
		if favorite_games.has(bodies.get_parent().object_name):
			return true
			break
		else:
			pass
	return false

func _get_called_to_play_game(game_reference: Node3D):
	if Globals.game_paused == false:
		idle.stop()
		targeted_position_is_object = game_reference
		var random_choice_of_chair = randi_range(0, targeted_position_is_object.get_node("Sit positions").get_child_count() - 1)
		_walk_to(targeted_position_is_object.get_node("Sit positions").get_child(random_choice_of_chair).global_position)
		targeted_sitting_position = random_choice_of_chair

func _walk_to_random(min_x, max_x, min_z, max_z):
	targeted_position_is_object = null
	var random_positon := Vector3(0,1,0)
	random_positon.x = randf_range(min_x + self.position.x, max_x + self.position.x)
	random_positon.z = randf_range(min_z + self.position.z, max_z + self.position.z)
	_walk_to(random_positon)

func _on_nav_navigation_finished() -> void:
	if is_going_to_interaction == false and is_on_interaction == false and Globals.game_paused == false:
		idle.start(randf_range(minimum_time_for_idle, maximum_time_for_idle))

func _on_idle_timeout() -> void:
	if Globals.game_paused == false and is_going_to_interaction == false and is_on_interaction == false:
		_walk_to_random(-5, 5, -5, 5)
	
func _leave_interaction():
	if is_instance_valid(targeted_position_is_object) == true and targeted_position_is_object is GambleSpot and Globals.game_paused == false:
		targeted_position_is_object._cancel_interact_GambleSpot(self)
		print("got up")
	is_on_interaction = false
	idle.start(randf_range(minimum_time_for_idle, maximum_time_for_idle))
	targeted_interactable_object_timer.start(randf_range(minimum_time_for_TIOT, maximum_time_for_TIOT))
	get_away_timer.start()
	_walk_to_random(-5, 5, -5, 5)


func _on_get_away_timer_timeout() -> void:
	if Globals.game_paused == false and is_going_to_interaction == false and is_on_interaction == false:
		_walk_to_random(-10, 10, -10, 10)
		targeted_interactable_object_timer.start(randf_range(minimum_time_for_TIOT, maximum_time_for_TIOT))
