extends Node

var game_paused: bool = false
var player_interacting: bool = false
var player_is_in_camera_animation: bool = false

var player_transform_storage: Array

func _process(delta: float) -> void:
	print(player_transform_storage)
