extends Node3D

@onready var npc = preload("res://Scenes/blackjack_npc.tscn")
@onready var card = preload("res://Scenes/card.tscn")
@onready var table_node = $table
@onready var deck_node: Node3D = $deck
@onready var gamecontrol: Panel = $CanvasLayer/gamecontrol
@onready var player: CharacterBody3D = $bj_player_test

var tween : Tween

var table : Array = []
var round_started : bool = false
var round : int = 0
var playing_npcs : Array = []
var gc_labels : Array = []

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
	
	for labels in gamecontrol.get_children():
		gc_labels.append(labels)

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
			new_npc.go_to_table(table[chairs][0])
			table[chairs][1] = 1
			new_npc.assigned_chair = true
			new_npc.name = str(chairs)
			playing_npcs.append(new_npc)
			new_npc.assigned_gc_label = gc_labels[int(new_npc.name)]
			new_npc.update_gc_label()
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

func distribute_cards():
	player.dealer_hand.append(deck.back())
	card_to_dealer(deck.pop_back(), Vector3(0.40, 0, 0), Vector3(180, 0, 0))
	player.dealer_hand.append(deck.back())
	card_to_dealer(deck.pop_back(), Vector3(0.40, 0, 0), Vector3.ZERO)
	gc_labels[6].text = "Dealer\nHand: " + str(player.dealer_hand)
	for npcs in playing_npcs:
		npcs.hand1.append(deck.back)
		card_to_npc(deck.pop_back(), npcs, npcs.hand_marker, npcs.hand1)
		npcs.hand1.append(deck.back)
		card_to_npc(deck.pop_back(), npcs, npcs.hand_marker, npcs.hand1)
		npcs.update_gc_label()

func card_to_dealer(card : Node3D, pos : Vector3, rot : Vector3):
	#cria um tween
	tween = create_tween()
	#propriedades do tween
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	#o tween em si
	tween.set_parallel(true)
	tween.tween_property(card, "position", pos + Vector3(float(player.dealer_hand.size()) / 20,\
	float(player.dealer_hand.find(card)) / 524, 0), 1)
	tween.tween_property(card, "rotation_degrees", rot, 0.66)

func card_to_npc(card : Node3D, who : CharacterBody3D, marker : Marker3D, hand):
	#cria um tween
	tween = create_tween()
	#propriedades do tween
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	#o tween em si
	tween.set_parallel(true)
	tween.tween_property(card, "position", marker.global_position + Vector3(float(hand.size()) / 20,\
	float(hand.find(card)) / 524, 0), 1)
	tween.tween_property(card, "rotation_degrees", Vector3.ZERO, 0.66)

func pass_turn():
	if round_started == false and playing_npcs.size() > 1:
		round_started = true
		shuffle_deck()
		distribute_cards()
	elif round_started == false and playing_npcs.size() <= 1:
		pass
	else:
		round += 1
	gc_labels[5].text = "Round " + str(round)

func restart_game():
	for labels in gc_labels.size() - 1:
		gc_labels[labels].text = "Player X\nAI:\nHand: [\n\n]"
	
	if playing_npcs.size() == 5:
		playing_npcs[4].queue_free()
		playing_npcs.pop_at(4)
		table[4][1] = 0
	if playing_npcs.size() == 4:
		playing_npcs[3].queue_free()
		playing_npcs.pop_at(3)
		table[3][1] = 0
	if playing_npcs.size() == 3:
		playing_npcs[2].queue_free()
		playing_npcs.pop_at(2)
		table[2][1] = 0
	if playing_npcs.size() == 2:
		playing_npcs[1].queue_free()
		playing_npcs.pop_at(1)
		table[1][1] = 0
	if playing_npcs.size() == 1:
		playing_npcs[0].queue_free()
		playing_npcs.pop_at(0)
		table[0][1] = 0
	
	round = 0
	round_started = false
	gc_labels[5].text = "Round " + str(round)

func quit_game():
	get_tree().quit()
