extends Node3D

func _call_player():
	print("Called Player")

func _shuffle_deck():
	print("Shuffled Deck")

func _pass_turn():
	print("Passed Turn")

func _restart_game():
	print("Restarted Game")

func _quit_game():
	get_tree().quit()
