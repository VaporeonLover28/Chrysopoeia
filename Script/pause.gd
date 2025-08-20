extends CanvasLayer

@onready var shop_menu: Control = $"../Shop Menu/Shop"

func _ready() -> void:
	visible = false

func _unhandled_input(event: InputEvent) -> void:
	if !visible:
		if event.is_action_pressed("esc") and !shop_menu.opened and !get_tree().paused:
			visible = true
			get_tree().paused = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		if event.is_action_pressed("esc"):
			resume()

func resume():
	Globals.game_paused = false
	get_tree().paused = false
	visible = false

func _on_button_resume_pressed() -> void:
	resume()

func _on_button_settings_pressed() -> void:
	pass 

func _on_button_leave_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()
