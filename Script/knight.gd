extends NPC;

@onready var wait_time_to_enter_casino: Timer = $"Wait Time To Enter Casino"

@export var minimum_time_to_enter: float
@export var maximum_time_to_enter: float

func _ready() -> void:
	wait_time_to_enter_casino.start(randf_range(minimum_time_to_enter, maximum_time_to_enter))
	idle.start(randf_range(minimum_time_for_idle, maximum_time_for_idle))
	print(idle.time_left)

func _enter_the_casino() -> void:
	_walk_to(world_scene.get_node("Enter point for npc").position)
	await nav.navigation_finished
	targeted_interactable_object_timer.start(randf_range(minimum_time_for_TIOT, maximum_time_for_TIOT))
	
func _on_idle_timeout() -> void:
	if Globals.game_paused == false:
		print("knight out")
		_walk_to_random(-2, 2, -4.75, 1.5)
