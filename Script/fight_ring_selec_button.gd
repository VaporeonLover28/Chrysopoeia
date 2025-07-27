extends Button

@onready var fight_ring: Node3D = $"../../../../../../.."

@export var slot_ref : int

func _on_pressed() -> void:
	fight_ring.select_creature(self)
