extends CharacterBody3D

@onready var nav: NavigationAgent3D = $nav

var assigned_chair : bool = false
var is_sat_down : bool = false

func _process(delta: float) -> void:
	if is_sat_down == false:
		var destination = nav.get_next_path_position()
		var local_destination = destination - global_position
		var dir = local_destination.normalized()
		velocity = dir * 2
		look_at(transform.basis.z * -1)
		rotation.x = 0
		rotation.z = 0
	elif velocity != Vector3.ZERO:
		velocity = Vector3.ZERO
		#_look_at_player()
	
	move_and_slide()

func _go_to_table(chair_pos):
	#print(chair_pos)
	nav.set_target_position(chair_pos)

func _on_nav_navigation_finished() -> void:
	is_sat_down = true

func _look_at_player():
	look_at($"../bj_player_test".position)
	rotation.x = 0
	rotation.z = 0
