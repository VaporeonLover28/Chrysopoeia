extends Control

func _ready() -> void:
	MusicPlayer.menutheme.play()
func _on_start_btn_pressed() -> void:
	MusicPlayer.menutheme.play()
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
	
func _on_load_btn_pressed() -> void:
	pass # Replace with function body.

func _on_options_btn_pressed() -> void:
	pass # Replace with function body.

func _on_quit_btn_pressed() -> void:
	get_tree().quit()
