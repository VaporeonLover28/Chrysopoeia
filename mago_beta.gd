extends Node3D

var speed = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(deg_to_rad(speed * 30))
	speed *= 1.001
	position = Vector3(0, speed, 0)
