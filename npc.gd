extends CharacterBody3D; class_name NPC;

@onready var nav: NavigationAgent3D = $nav
@onready var idle: Timer = $idle

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

func _walk_to_random(min_x, max_x, min_z, max_z):
	var random_positon := Vector3.ZERO
	random_positon.x = randf_range(min_x, max_x)
	random_positon.z = randf_range(min_z, max_z)
	nav.set_target_position(random_positon)

func _on_nav_target_reached() -> void:
	idle.start()

func _on_idle_timeout() -> void:
	_walk_to_random(-2, 2, -2, 2)
