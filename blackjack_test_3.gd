extends Node3D

@onready var npc = preload("res://blackjack_npc.tscn")
@onready var table_node = $table

var table : Array = []
var playing_npcs : Array = []

func _ready():
	#adds a new chair in the table array
	for chairs in table_node.get_child_count():
		#excludes the table mesh from chair count
		if table_node.get_child(chairs) is Marker3D:
			#chair is [position, is_taken]
			table.append([table_node.get_child(chairs).position, 0])
			#print("New Chair, pos " + str(table[chairs - 1][0]))
			#print(table)

func _call_player():
	#instantiate new npc away from table (visual effect for testing)
	#call the funcion on the npc to come to the table
	#add the npc to the npc array
	var new_npc = npc.instantiate()
	new_npc.position = Vector3(randf_range(-3, 3), 0.342, -6)
	add_child(new_npc)
	for chairs in table.size():
		if table[chairs][1] == 0 and new_npc.assigned_chair == false:
			print("Chair Position: " + str(table[chairs][0]))
			new_npc._go_to_table(table[chairs][0])
			table[chairs][1] = 1
			new_npc.assigned_chair = true
		else:
			pass
	print("Called Player")

func _shuffle_deck():
	print("Shuffled Deck")

func _pass_turn():
	print("Passed Turn")

func _restart_game():
	print("Restarted Game")

func _quit_game():
	get_tree().quit()
