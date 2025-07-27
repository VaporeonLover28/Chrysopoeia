extends OmniLight3D

@onready var change: Timer = $change

func _on_change_timeout() -> void:
	var chosen = randi_range(1, 10)
	if chosen <= 2:
		light_energy = 0.1
		await get_tree().create_timer(0.1).timeout
		light_energy = 1
	elif chosen >= 9:
		light_energy = 2
		await get_tree().create_timer(0.1).timeout
		light_energy = 1
