extends AnimatedSprite3D

func _on_timer_timeout() -> void:
	var anim = randi_range(0, 1)
	if anim == 0:
		play("closed")
	else:
		play("open")
