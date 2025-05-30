extends CharacterBody3D; class_name NPC;

@onready var nav: NavigationAgent3D = $nav
@onready var walk_random: Timer = $walk_random

func _process(delta: float) -> void:
	if walk_random.is_stopped():
		if nav.is_navigation_finished() == true:
			walk_random.start()
	
	if not is_on_floor():
		velocity.y += 9.8 * delta
	
	var destino = nav.get_next_path_position()
	var local_destino = destino - global_position
	var dir = local_destino.normalized()
	velocity = dir * 2
	move_and_slide()

func _on_walk_random_timeout() -> void:
	var random_positon := Vector3.ZERO
	random_positon.x = randf_range(-5.0,5)
	random_positon.z = randf_range(-5.0,5)
	nav.set_target_position(random_positon)
