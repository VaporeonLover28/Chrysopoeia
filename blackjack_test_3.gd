extends Node3D

@onready var npc = preload("res://blackjack_npc.tscn")
@onready var card = preload("res://card.tscn")
@onready var table_node = $table
@onready var deck_node: Node3D = $deck

var table : Array = []
var round_started : bool = false
var playing_npcs : Array = []

var standard_deck : Array = [
	["Clubs", "Ace", "A"], ["Hearts", "Ace", "A"], ["Spades", "Ace", "A"], ["Diamonds", "Ace", "A"], 
	["Clubs", "Two", "2"], ["Hearts", "Two", "2"], ["Spades", "Two", "2"], ["Diamonds", "Two", "2"], 
	["Clubs", "Three", "3"], ["Hearts", "Three", "3"], ["Spades", "Three", "3"], ["Diamonds", "Three", "3"], 
	["Clubs", "Four", "4"], ["Hearts", "Four", "4"], ["Spades", "Four", "4"], ["Diamonds", "Four", "4"], 
	["Clubs", "Five", "5"], ["Hearts", "Five", "5"], ["Spades", "Five", "5"], ["Diamonds", "Five", "5"], 
	["Clubs", "Six", "6"], ["Hearts", "Six", "6"], ["Spades", "Six", "6"], ["Diamonds", "Six", "6"],  
	["Clubs", "Seven", "7"], ["Hearts", "Seven", "7"], ["Spades", "Seven", "7"], ["Diamonds", "Seven", "7"], 
	["Clubs", "Eight", "8"], ["Hearts", "Eight", "8"], ["Spades", "Eight", "8"], ["Diamonds", "Eight", "8"], 
	["Clubs", "Nine", "9"], ["Hearts", "Nine", "9"], ["Spades", "Nine", "9"], ["Diamonds", "Nine", "9"], 
	["Clubs", "Ten", "10"], ["Hearts", "Ten", "10"], ["Spades", "Ten", "10"], ["Diamonds", "Ten", "10"], 
	["Clubs", "Jack", "J"], ["Hearts", "Jack", "J"], ["Spades", "Jack", "J"], ["Diamonds", "Jack", "J"], 
	["Clubs", "Queen", "Q"], ["Hearts", "Queen", "Q"], ["Spades", "Queen", "Q"], ["Diamonds", "Queen", "Q"], 
	["Clubs", "King", "K"], ["Hearts", "King", "K"], ["Spades", "King", "K"], ["Diamonds", "King", "K"]
]

var deck = []
var shuffler_deck = []

func _ready():
	instantiate_cards()
	#adds a new chair in the table array
	for chairs in table_node.get_child_count():
		#excludes the table mesh from chair count
		if table_node.get_child(chairs) is Marker3D:
			#chair is [position, is_taken]
			table.append([table_node.get_child(chairs).position, 0])
			#print("New Chair, pos " + str(table[chairs - 1][0]))
			#print(table)

func instantiate_cards():
	for instance in 52:
		#print("Card number " + str(instance))
		var new_card = card.instantiate()
		deck.push_back(new_card)
		#new_card.position.x = float(deck.find(new_card)) / 52 
		new_card.position.y = float(deck.find(new_card)) / 1048
		new_card.rotation_degrees.x = 180
		new_card.name = "card" + str(instance)
		new_card.chosen_suit = standard_deck[instance][0]
		new_card.chosen_rank = standard_deck[instance][1]
		new_card.chosen_value = standard_deck[instance][2]
		deck_node.add_child(new_card)

func call_player():
	#instantiate new npc away from table (visual effect for testing)
	#call the funcion on the npc to come to the table
	#add the npc to the npc array
	var new_npc = npc.instantiate()
	new_npc.position = Vector3(randf_range(-3, 3), 0.342, -6)
	add_child(new_npc)
	for chairs in table.size():
		if table[chairs][1] == 0 and new_npc.assigned_chair == false:
			#print("Picked chair " + str(chairs + 1) + " at position " + str(table[chairs][0]))
			new_npc._go_to_table(table[chairs][0])
			table[chairs][1] = 1
			new_npc.assigned_chair = true
		#elif table[chairs][1] != 0:
			#print("Chair " + str(chairs + 1) + " is taken")
		#else:
			#print("Already picked another chair")
	#print("Called Player")

func shuffle_deck():
	#print("Shuffled Deck")
	for card in deck.size():
		var in_shuffle_hand = deck.pick_random()
		#print(in_shuffle_hand)
		shuffler_deck.push_back(in_shuffle_hand)
		deck.erase(in_shuffle_hand)
		if shuffler_deck.size() == 52:
			deck.append_array(shuffler_deck)
			shuffler_deck.clear()
			#print(deck)
			square_deck()

func square_deck():
	for card in deck:
		#card.position.x = float(deck.find(card)) / 52 
		card.position.y = float(deck.find(card)) / 1048

func pass_turn():
	print("Passed Turn")

func restart_game():
	print("Restarted Game")

func quit_game():
	get_tree().quit()
