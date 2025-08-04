extends Sprite3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.money > 0:
		rotation_degrees.y += Globals.money / 100
