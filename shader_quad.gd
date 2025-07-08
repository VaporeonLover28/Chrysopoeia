extends MeshInstance3D

@export var enabled : bool

func _ready() -> void:
	if enabled:
		visible = true
