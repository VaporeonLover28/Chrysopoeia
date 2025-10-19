extends Control

var ui_bus = AudioServer.get_bus_index("UI")
var bgm_bus = AudioServer.get_bus_index("BGM")
var sfx_bus = AudioServer.get_bus_index("SFX")

func _ready() -> void:
	get_tree().paused = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

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

func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0,linear_to_db(value))

func _on_h_slider_3_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bgm_bus,linear_to_db(value))

func _on_h_slider_4_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus,linear_to_db(value))

func _on_h_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		$TabContainer/Audio/galunga.play()

func _on_h_slider_3_drag_ended(value_changed: bool) -> void:
	if value_changed:
		$TabContainer/Audio/galunga2.play()

func _on_h_slider_4_drag_ended(value_changed: bool) -> void:
	if value_changed:
		$TabContainer/Audio/galunga3.play()
