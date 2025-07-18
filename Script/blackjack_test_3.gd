extends Node3D

@onready var npc = preload("res://Scenes/blackjack_npc.tscn")
@onready var card = preload("res://Scenes/card.tscn")
@onready var table_node = $table
@onready var deck_node: Node3D = $deck
@onready var gamecontrol: Panel = $CanvasLayer/gamecontrol
@onready var player: CharacterBody3D = $bj_player_test
@onready var card_distr_timer: Timer = $card_distr_timer

var tween : Tween

var table : Array = []
var round_started : bool = false
var distribution_number : float = 0.0
var round : int = 0
var playing_npcs : Array = []
var gc_labels : Array = []
var round_order_npcs : Array = []

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
	##adds a new chair in the table array for referencing positions
	for chairs in table_node.get_child_count():
		#excludes the table mesh from chair count
		if table_node.get_child(chairs) is Marker3D:
			#chair is [position, is_taken]
			table.append([table_node.get_child(chairs).position, 0])
			#print("New Chair, pos " + str(table[chairs - 1][0]))
			#print(table)
	
	##adding labels for game control (top right panel)
	for labels in gamecontrol.get_children():
		gc_labels.append(labels)

##putting the cards in the screen
func instantiate_cards():
	for instance in 52:
		#print("Card number " + str(instance))
		##adds a new card instance
		var new_card = card.instantiate()
		##to the deck
		deck.push_back(new_card)
		#new_card.position.x = float(deck.find(new_card)) / 52 
		##puts each card slightly above the previous (stacking deck)
		new_card.position.y = float(deck.find(new_card)) / 1048
		##each card upside down
		new_card.rotation_degrees.x = 180
		new_card.name = "card" + str(instance)
		##every card is based on the standard deck, each suit and rank
		new_card.chosen_suit = standard_deck[instance][0]
		new_card.chosen_rank = standard_deck[instance][1]
		new_card.chosen_value = standard_deck[instance][2]
		deck_node.add_child(new_card)

##calls an npc (currently instantiating a new one) to a chair
func call_player():
	var new_npc = npc.instantiate()
	##instantiate new npc away from table (visual effect for testing)
	new_npc.position = Vector3(randf_range(-3, 3), 0.342, -6)
	add_child(new_npc)
	##checking if each chair is taken
	for chairs in table.size():
		##if it isn't (free chair)
		if table[chairs][1] == 0 and new_npc.assigned_chair == false:
			#print("Picked chair " + str(chairs + 1) + " at position " + str(table[chairs][0]))
			##call the funcion on the npc script to come to the chair
			new_npc.go_to_table(table[chairs][0])
			##occupy the chair
			table[chairs][1] = 1
			new_npc.assigned_chair = true
			new_npc.name = str(chairs)
			##add the npc to the npc array
			playing_npcs.append(new_npc)
			##adds a game control label to the npc for testing
			new_npc.assigned_gc_label = gc_labels[int(new_npc.name)]
			new_npc.update_gc_label()
		#elif table[chairs][1] != 0:
			#print("Chair " + str(chairs + 1) + " is taken")
		#else:
			#print("Already picked another chair")
	#print("Called Player")

##setting a table order (left to right) for the rounds playing
func set_round_order():
	match playing_npcs.size():
		2:
			round_order_npcs.append(playing_npcs[1])
			round_order_npcs.append(playing_npcs[0])
		3:
			round_order_npcs.append(playing_npcs[1])
			round_order_npcs.append(playing_npcs[0])
			round_order_npcs.append(playing_npcs[2])
		4:
			round_order_npcs.append(playing_npcs[3])
			round_order_npcs.append(playing_npcs[1])
			round_order_npcs.append(playing_npcs[0])
			round_order_npcs.append(playing_npcs[2])
		5:
			round_order_npcs.append(playing_npcs[3])
			round_order_npcs.append(playing_npcs[1])
			round_order_npcs.append(playing_npcs[0])
			round_order_npcs.append(playing_npcs[2])
			round_order_npcs.append(playing_npcs[4])

func shuffle_deck():
	#print("Shuffled Deck")
	for card in deck.size():
		##picks a random card
		var in_shuffle_hand = deck.pick_random()
		#print(in_shuffle_hand)
		##puts it in a side shuffler deck
		shuffler_deck.push_back(in_shuffle_hand)
		##takes it away from the normal deck
		deck.erase(in_shuffle_hand)
		##adds the shuffled cards back to the deck when done
		if shuffler_deck.size() == 52:
			deck.append_array(shuffler_deck)
			shuffler_deck.clear()
			#print(deck)
			square_deck()

##puts each card in it's position on the deck (not needed but a nice touch)
func square_deck():
	for card in deck:
		#card.position.x = float(deck.find(card)) / 52 
		card.position.y = float(deck.find(card)) / 1048

##animation for card distributing
func distribute_cards():
	##increases a number 
	distribution_number += 1
	##just to be sure i guess (i forgot why i had this)
	gc_labels[6].text = "Dealer\nValue:" + str(player.dealer_hand_value) + "\nHand:\n"
	
	##defines how many cards need to be distributed
	##two for every npc + two for dealer
	var cards_to_distribute : int = round_order_npcs.size() * 2 + 2
	
	##every third (number) is a break in the animation
	if distribution_number / 3 - floor(distribution_number / 3) == 0:
		#print("Skip")
		pass
	##every first (number) gives a card
	elif int(distribution_number - 1) % 3 == 0:
		##the dealer's first card is side down
		if distribution_number / 3 > round_order_npcs.size():
			#print("Distr " + str(distribution_number) + ", card 1 to dealer")
			##appends the top card to the dealer hand
			player.dealer_hand.append(deck.back())
			##gives it to the dealer
			card_to_dealer(deck.pop_back(), Vector3(0.40, 0, 0), Vector3(180, 0, 0))
		else:
		##the npc's first and second cards are identical
			#print("Distr " + str(distribution_number) + ", card 1 to npc " + str(int(floor(distribution_number / 3))))
			##appends the top card to the npc's hand
			round_order_npcs[int(floor(distribution_number / 3))].hand.append(deck.back())
			##gives it to them
			card_to_npc(deck.pop_back(), round_order_npcs[int(floor(distribution_number / 3))])
	else:
		##the dealer's first card is side up
		if distribution_number / 3 > round_order_npcs.size():
			#print("Distr " + str(distribution_number) + ", card 2 to dealer")
			##appends the top card to the dealer hand
			player.dealer_hand.append(deck.back())
			##gives it to the dealer
			card_to_dealer(deck.pop_back(), Vector3(0.40, 0, 0), Vector3.ZERO)
			##updates the game control label for the dealer
			for cards in player.dealer_hand:
				gc_labels[6].text += str(cards.rank) + " of " + str(cards.suit) + ",\n"
		else:
		##the npc's first and second cards are identical
			#print("Distr " + str(distribution_number) + ", card 2 to npc " + str(int(floor(distribution_number / 3))))
			##appends the top card to the npc's hand
			round_order_npcs[int(floor(distribution_number / 3))].hand.append(deck.back())
			##gives it to them
			card_to_npc(deck.pop_back(), round_order_npcs[int(floor(distribution_number / 3))])

##tween to send a card to the dealer
func card_to_dealer(card : Node3D, pos : Vector3, rot : Vector3):
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	##with a little horizontal and vertical separation
	tween.tween_property(card, "position", pos + Vector3(float(player.dealer_hand.size()) / 20,\
	float(player.dealer_hand.find(card)) / 512, 0), 1)
	##makes it rotate to where it is supposed to
	tween.tween_property(card, "rotation_degrees", rot, 0.66)

##tween to send a card to an npc
func card_to_npc(card : Node3D, who : CharacterBody3D):
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(card, "global_position", who.hand_marker.global_position + Vector3(float(who.hand.size()) / 20,\
	float(who.hand.size()) / 512, 0), 1)
	tween.tween_property(card, "rotation_degrees", Vector3.ZERO, 0.66)
	##updates the game control label
	who.update_gc_label()

func pass_turn():
	if round_started == false and playing_npcs.size() > 1:
		round_started = true
		set_round_order()
		shuffle_deck()
		$card_distr_timer.start()
	elif round_started == false and playing_npcs.size() <= 1:
		pass
	else:
		round += 1
	gc_labels[5].text = "Turn " + str(round)

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
	round_order_npcs.clear()
	
	round = 0
	round_started = false
	distribution_number = 0
	gc_labels[5].text = "Round " + str(round)

func quit_game():
	get_tree().quit()

func _on_card_distr_timer_timeout() -> void:
	##if still distributing cards
	if distribution_number < (round_order_npcs.size() + 1) * 3:
		distribute_cards()
	else:
		print("Stopped timer")
		card_distr_timer.stop()
