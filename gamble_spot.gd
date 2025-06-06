extends InteractableObject; class_name GambleSpot


@onready var camera: Camera3D = $camera
@onready var marker: Marker3D = $marker
@onready var sit_positions: Node3D = $"Sit positions"
#camera transition vars
var is_pulling : bool
var chosen_sitting_transition
#export varibles to change depending on the game
@export var chair_postion_list : Array[Array]
@export var game_machice_scene : String
# other vars
var player_is_sitting = false
var save_player_ref : CharacterBody3D
var chosen_sitting_position: int

func _ready() -> void:
	#makes sitting spots based on chair_postion_list
	for item in chair_postion_list.size():
		var new_chair_position = Marker3D.new()
		new_chair_position.position = chair_postion_list[item][0]
		sit_positions.add_child(new_chair_position)
		
# Called when the node enters the scene tree for the first time.
func _interact_GambleSpot(object_ref):
	if _ASAT() != true:
		if object_ref.name == "Player":
			#makes player sit
			Globals.player_interacting = true
			#checks for marker with the smallest postion distance to the player so he can sit
			chosen_sitting_transition = null
			var smallest_distance : float = 10
			for item in sit_positions.get_child_count():
				if smallest_distance > object_ref.global_position.distance_to(sit_positions.get_child(item).global_position)\
				and chair_postion_list[item][1] != false :
					item = chosen_sitting_position
					smallest_distance = object_ref.global_position.distance_to(sit_positions.get_child(item).global_position)
			chair_postion_list[chosen_sitting_position][1] = false
			chosen_sitting_transition = sit_positions.get_child(chosen_sitting_position)
			is_pulling = true
			save_player_ref = object_ref
			_camera_transition(object_ref)
			await get_tree().create_timer(0.2).timeout
			player_is_sitting = true
			print(chair_postion_list)
			
		
func _cancel_interact_GambleSpot(object_ref):
	for item in sit_positions.get_child_count():
		if sit_positions.get_child(item).global_position.distance_to(camera.global_position - Vector3(0, 1.2, 0)) <= 0.5:
			print("foi")
			chair_postion_list[item][1] = true
		
	if object_ref == save_player_ref:
		player_is_sitting = false
		save_player_ref = null
	print(chair_postion_list)

func _camera_transition(player) -> void:
	player.camera.current = false
	camera.global_position = player.camera.global_position
	camera.rotation = player.camera.rotation
	camera.current = true

func _process(delta: float) -> void:
	if is_pulling == true:
		_pull_camera()
	if Input.is_action_just_pressed("e") and player_is_sitting == true:
		_cancel_interact_GambleSpot(save_player_ref)

func _pull_camera():
	camera.global_position = lerp(camera.global_position, chosen_sitting_transition.global_position + Vector3(0, 1.2, 0), get_process_delta_time() * 3)
	camera.look_at($CSGBox3D.global_position)
func _start_game():
	pass

#returns if all sits are taken
func _ASAT():
	var all_got_taken: bool = false
	for item in chair_postion_list.size():
		if chair_postion_list[item][1] == false:
			pass
		else:
			all_got_taken = false
			break
		all_got_taken = true
	return all_got_taken
