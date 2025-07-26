extends Node3D

@onready var player_ref: CharacterBody3D = $"../../../../Player"
@onready var camera: Camera3D = $"../camera"
@onready var model: StaticBody3D = $"../Model"

@export var chair_postion_list : Array[Array]

var is_pulling : bool = false
var chosen_sitting_transition: Marker3D

var player_is_sitting = false
var save_player_ref : CharacterBody3D
var chosen_sitting_position: int


func _ready() -> void:
	#makes sitting spots based on chair_postion_list
	for item in chair_postion_list.size():
		var new_chair_position = Marker3D.new()
		new_chair_position.position = chair_postion_list[item][0]
		self.add_child(new_chair_position)
		
func _sit_characther(object_ref):
	await get_tree().create_timer(0.1).timeout
	if _ASAT() != true:
		#makes player sit
		#checks for marker with the smallest postion distance to the player so he can sit, removing the spot from the pool
		chosen_sitting_transition = null
		chosen_sitting_position = 10
		var smallest_distance : float = 10
		for item in self.get_child_count():
			if smallest_distance > object_ref.global_position.distance_to(self.get_child(item).global_position)\
			and chair_postion_list[item][1] != false :
				chosen_sitting_position = item 
				smallest_distance = object_ref.global_position.distance_to(self.get_child(item).global_position)
		chair_postion_list[chosen_sitting_position][1] = false
		if object_ref.name == "Player":
			chosen_sitting_transition = self.get_child(chosen_sitting_position)
			save_player_ref = object_ref
			#_camera_transition(object_ref)
			object_ref.global_position = chosen_sitting_transition.global_position
			player_is_sitting = true
			Globals.player_interacting = true

func _stand_characther_up(object_ref):
	for item in self.get_child_count():
		if  self.get_child(item).global_position.distance_to(object_ref.global_position) <= 0.2:
			chair_postion_list[item][1] = true
	if object_ref == save_player_ref:
		#Globals.player_interacting = false
		#save_player_ref.camera.current = true
		player_is_sitting = false
		save_player_ref = null
		Globals.player_interacting = false

func _camera_transition(player) -> void:
	#await get_tree().create_timer(0.1).timeout
	#is_pulling = true
	#_pull_camera(player)
	#player.camera.current = false
	#camera.global_position = player.camera.global_position
	#camera.rotation = player.camera.rotation
	#camera.current = true
	pass


func _physics_process(delta: float) -> void:
	#if is_pulling == true and player_ref != null:
		#player_ref.camera.look_at(model.global_position)
		#_pull_camera(player_ref)
	pass

func _pull_camera(player):
	#var tween = create_tween()
	#tween.tween_property(camera, "global_position", chosen_sitting_transition.global_position + + Vector3(0, 1.2, 0), 1)
	#camera.global_position = lerp(camera.global_position, chosen_sitting_transition.global_position + Vector3(0, 1.2, 0), get_process_delta_time() * 3)
	#camera.look_at(model.global_position)
	#if chosen_sitting_transition.global_position.distance_to(camera.global_position - Vector3(0, 1.2, 0)) <= 0.1:
		#is_pulling = false
		#Globals.player_is_in_camera_animation = false
	pass

#checks then returns if all sits are taken
func _ASAT():
	var all_got_taken: bool = false
	for item in chair_postion_list.size():
		if chair_postion_list[item - 1][1] == false:
			pass
			print("ui")
		else:
			all_got_taken = false
			break
		all_got_taken = true
	return all_got_taken

#check if the sitting position is taken
func _SICSOC(choice_of_chair: int):
	if chair_postion_list[choice_of_chair][1] == true:
		return true
	else:
		return false
