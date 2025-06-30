extends CharacterBody3D

@onready var nav: NavigationAgent3D = $nav

func _process(delta: float) -> void:
	var destination = nav.get_next_path_position()
	var local_destination = destination - global_position
	var dir = local_destination.normalized()

func _go_to_table(table, seat):
	nav.set_target_position(table[seat])
