extends Node3D

var speed = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(deg_to_rad(speed * 10))
	speed *= 1.005
	position.y += speed / 4000
