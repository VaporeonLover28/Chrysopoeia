extends CharacterBody3D

@onready var nav: NavigationAgent3D = $nav

var assigned_chair : bool = false

func _process(delta: float) -> void:
	var destination = nav.get_next_path_position()
	var local_destination = destination - global_position
	var dir = local_destination.normalized()
	velocity = dir * 2
	
	move_and_slide()

func _go_to_table(chair_pos):
	print(chair_pos)
	nav.set_target_position(chair_pos)
