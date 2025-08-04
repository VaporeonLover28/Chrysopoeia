extends Node3D

@onready var player_ref: CharacterBody3D = $"../../../../Player"
@onready var model: StaticBody3D = $"../Model"

@export var chair_postion_list : Array[Array]

var is_pulling : bool = false
var chosen_sitting_transition: Marker3D

var player_is_sitting = false
var save_player_ref : CharacterBody3D
var chosen_sitting_position: int

var tween : Tween

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
			_pull_camera(object_ref)
			player_is_sitting = true
			Globals.player_interacting = true

func _stand_characther_up(object_ref):
	for item in self.get_child_count():
		if  self.get_child(item).global_position.distance_to(object_ref.global_position) <= 0.2:
			chair_postion_list[item][1] = true
	if object_ref == save_player_ref:
		Globals.player_interacting = false
		player_is_sitting = false
		save_player_ref = null
		Globals.player_interacting = false

func _physics_process(delta: float) -> void:
	pass

func _pull_camera(player):
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(true)
	tween.tween_property(player_ref.pivot, "rotation_degrees", Vector3(0, 0, 0), 1.25)
	tween.tween_property(player_ref.camera, "rotation_degrees", Vector3(0, 0, 0), 1.25)
	tween.tween_property(player_ref.camera, "global_position", \
	chosen_sitting_transition.global_position + Vector3(0, 0.6, 0), 1.25)
	await get_tree().create_timer(1.25).timeout
	player.global_position = chosen_sitting_transition.global_position
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
