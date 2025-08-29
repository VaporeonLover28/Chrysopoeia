extends Control

func _ready() -> void:
	get_tree().paused = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _on_h_slider_value_changed(value: float) -> void:
	$TabContainer/Audio/galunga.play()
	AudioServer.set_bus_volume_db(0,value)

func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_vsync_button_toggled(toggled_on: bool) -> void:
	if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)

func _on_h_slider_2_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1,value)
	$TabContainer/Audio/galunga.play()

func _on_h_slider_3_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2,value)
	$TabContainer/Audio/galunga2.play()

func _on_h_slider_4_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(3,value)
	$TabContainer/Audio/galunga3.play()
