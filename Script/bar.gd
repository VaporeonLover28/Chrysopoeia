extends InteractableObject

@onready var world: Node3D = $"../../.."
@onready var camera: Camera3D = $camera
@onready var sit_positions: Node = $"Sit positions"

func _interact_Bar(object_ref):
	sit_positions._sit_characther(object_ref)
	if object_ref.name == "Player":
		world.get_node("Bar UI").get_child(0)._show_bar_ui(self)

func _cancel_interact_Bar(object_ref):
	sit_positions._stand_characther_up(object_ref)
