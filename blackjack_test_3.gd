extends Node3D

@onready var npc = preload("res://blackjack_npc.tscn")
@onready var card = preload("res://card.tscn")
@onready var table_node = $table
@onready var deck_node: Node3D = $deck

var table : Array = []
var round_started : bool = false
var playing_npcs : Array = []

var standard_deck : Array = [
	["Hearts", "A"], ["Diamonds", "A"], ["Clubs", "A"], ["Spades", "A"], 
	["Hearts", "2"], ["Diamonds", "2"], ["Clubs", "2"], ["Spades", "2"], 
	["Hearts", "3"], ["Diamonds", "3"], ["Clubs", "3"], ["Spades", "3"], 
	["Hearts", "4"], ["Diamonds", "4"], ["Clubs", "4"], ["Spades", "4"], 
	["Hearts", "5"], ["Diamonds", "5"], ["Clubs", "5"], ["Spades", "5"], 
	["Hearts", "6"], ["Diamonds", "6"], ["Clubs", "6"], ["Spades", "6"],  
	["Hearts", "7"], ["Diamonds", "7"], ["Clubs", "7"], ["Spades", "7"], 
	["Hearts", "8"], ["Diamonds", "8"], ["Clubs", "8"], ["Spades", "8"], 
	["Hearts", "9"], ["Diamonds", "9"], ["Clubs", "9"], ["Spades", "9"], 
	["Hearts", "10"], ["Diamonds", "10"], ["Clubs", "10"], ["Spades", "10"], 
	["Hearts", "J"], ["Diamonds", "J"], ["Clubs", "J"], ["Spades", "J"], 
	["Hearts", "Q"], ["Diamonds", "Q"], ["Clubs", "Q"], ["Spades", "Q"], 
	["Hearts", "K"], ["Diamonds", "K"], ["Clubs", "K"], ["Spades", "K"]
]

var deck = []

func _ready():
	_instantiate_cards()
	#adds a new chair in the table array
	for chairs in table_node.get_child_count():
		#excludes the table mesh from chair count
		if table_node.get_child(chairs) is Marker3D:
			#chair is [position, is_taken]
			table.append([table_node.get_child(chairs).position, 0])
			#print("New Chair, pos " + str(table[chairs - 1][0]))
			#print(table)

func _instantiate_cards():
	for instance in 52:
		print("Card number " + str(instance))
		var new_card = card.instantiate()
		deck.push_back(new_card)
		new_card.position.x = float(deck.find(new_card)) / 52 
		new_card.position.y = float(deck.find(new_card)) / 1048 
		new_card.name = "card" + str(instance)
		deck_node.add_child(new_card)
		new_card._change_values(standard_deck[instance][0], standard_deck[instance][1])

func _call_player():
	#instantiate new npc away from table (visual effect for testing)
	#call the funcion on the npc to come to the table
	#add the npc to the npc array
	var new_npc = npc.instantiate()
	new_npc.position = Vector3(randf_range(-3, 3), 0.342, -6)
	add_child(new_npc)
	for chairs in table.size():
		if table[chairs][1] == 0 and new_npc.assigned_chair == false:
			print("Picked chair " + str(chairs + 1) + " at position " + str(table[chairs][0]))
			new_npc._go_to_table(table[chairs][0])
			table[chairs][1] = 1
			new_npc.assigned_chair = true
		elif table[chairs][1] != 0:
			print("Chair " + str(chairs + 1) + " is taken")
		else:
			print("Already picked another chair")
	#print("Called Player")

func _shuffle_deck():
	print("Shuffled Deck")

func _pass_turn():
	print("Passed Turn")

func _restart_game():
	print("Restarted Game")

func _quit_game():
	get_tree().quit()
