extends Node3D

var speed = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(deg_to_rad(speed * 10))
	if speed < 5000:
		speed *= 1.002
		position.y += speed / 4000
