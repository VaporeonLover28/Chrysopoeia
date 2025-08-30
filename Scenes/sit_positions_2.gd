extends Node3D

@onready var player_ref: CharacterBody3D = $"../../../../Player"
@onready var model: StaticBody3D = $"../Model"

@export var chair_postion_list : Array[Array]

var is_pulling : bool = false
var chosen_sitting_transition: Marker3D

var player_is_sitting = false
var save_player_ref : CharacterBody3D

var characters_sitting_count: int = 0

var tween : Tween

func _ready() -> void:
	#makes sitting spots based on chair_postion_list
	for item in chair_postion_list.size():
		var new_chair_position = Marker3D.new()
		new_chair_position.position = chair_postion_list[item][0]
		self.add_child(new_chair_position)
		
func _sit_character(object_ref):
	if object_ref.name == "Player":
		save_player_ref = object_ref
		_pull_camera(object_ref, get_parent().rotation_degrees + Vector3(0, 90, 0))
		player_is_sitting = true
		Globals.player_interacting = true

func _stand_character_up(object_ref):
	if object_ref == save_player_ref:
		Globals.player_interacting = false
		player_is_sitting = false
		save_player_ref = null

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	pass

func _pull_camera(player, rot_vec3):
	pass
	#tween = create_tween()
	#tween.set_trans(Tween.TRANS_SINE)
	#tween.set_ease(Tween.EASE_OUT)
	#tween.set_parallel(true)
	#tween.tween_property(player_ref.pivot, "rotation_degrees", Vector3(0, rot_vec3.y - 90, 0), 1.25)
	#tween.tween_property(player_ref.camera, "rotation_degrees", Vector3(-30, 0, 0), 1.25)
	##tween.tween_property(player_ref.camera, "global_position", \
	#$Marker3D.global_position + Vector3(0, 0.6, 0), 0.75)
	#await get_tree().create_timer(1.5).timeout
	#player.global_position = $"../Player Chair".global_position
#checks then returns if all sits are taken
func _ASAT():
	var all_got_taken: bool = false
	for item in chair_postion_list.size():
		if chair_postion_list[item - 1][1] == false:
			pass
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

func _CNSC():
	var count_character: int
	for item in chair_postion_list.size():
		if chair_postion_list[item - 1][1] == false:
			@warning_ignore("unassigned_variable_op_assign")
			count_character += 1
	print(count_character)
	return count_character
