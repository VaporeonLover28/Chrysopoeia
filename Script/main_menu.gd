extends Control

@onready var buttons: AnimatedSprite2D = $buttons
@onready var v_box_container: VBoxContainer = $VBoxContainer

var tween = Tween
func _ready() -> void:
	await get_tree().create_timer(0.25).timeout
	MusicPlayer.menutheme.play()
	buttons.play("default")
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(v_box_container,"position", Vector2(827,182), 2)

func _on_start_btn_pressed() -> void:
	MusicPlayer.menutheme.stop()
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
	
func _on_load_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Load_game.tscn")

func _on_options_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Options.tscn")

func _on_quit_btn_pressed() -> void:
	get_tree().quit()
