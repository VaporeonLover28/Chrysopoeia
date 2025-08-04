extends CanvasLayer

func _ready() -> void:
	visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		visible = true
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_button_resume_pressed() -> void:
	Globals.game_paused = false
	get_tree().paused = false
	visible = false

func _on_button_settings_pressed() -> void:
	pass 

func _on_button_leave_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()
