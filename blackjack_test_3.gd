extends Node3D

@onready var npc = preload("res://bj_npc_test.tscn")

var playing_npcs : Array = []

func _call_player():
	#instantiate new npc away from table (visual effect for testing)
	#call the funcion on the npc to come to the table
	#add the npc to the npc array
	var new_npc = npc.instantiate()
	new_npc.position = Vector3(randf_range(-3, 3), -0.342, -6)
	print("Called Player")

func _shuffle_deck():
	print("Shuffled Deck")

func _pass_turn():
	print("Passed Turn")

func _restart_game():
	print("Restarted Game")

func _quit_game():
	get_tree().quit()
