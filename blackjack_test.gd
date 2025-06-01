extends Control

#TO-DO
#players com caracteristicas diferentes de logica (adere a estrategia basica, aleatorio, medroso)
#regras mudaveis (focar agora em H17, 1 deck, hole card, late surrender, resplit to 4, no double-split, reno, 3:2 bonus)
#jogo acontecendo

#TO-DO NO JOGO REAL
#hole card do dealer

@onready var player_side: HBoxContainer = $players/HBoxContainer
@onready var new_player = preload("res://bj_player_test.tscn")
@onready var player_action: Timer = $player_action

#standard deck for shuffling a new deck
var standard_deck : Array = [
	["Hearts", "Ace"], ["Hearts", 2], ["Hearts", 3], ["Hearts", 4], 
	["Hearts", 5], ["Hearts", 6], ["Hearts", 7], ["Hearts", 8], 
	["Hearts", 9], ["Hearts", 10], ["Hearts", "Jack"], 
	["Hearts", "Queen"], ["Hearts", "King"], 
	["Diamonds", "Ace"], ["Diamonds", 2], ["Diamonds", 3], ["Diamonds", 4], 
	["Diamonds", 5], ["Diamonds", 6], ["Diamonds", 7], ["Diamonds", 8], 
	["Diamonds", 9], ["Diamonds", 10], ["Diamonds", "Jack"], 
	["Diamonds", "Queen"], ["Diamonds", "King"],
	["Clubs", "Ace"], ["Clubs", 2], ["Clubs", 3], ["Clubs", 4], 
	["Clubs", 5], ["Clubs", 6], ["Clubs", 7], ["Clubs", 8], 
	["Clubs", 9], ["Clubs", 10], ["Clubs", "Jack"], 
	["Clubs", "Queen"], ["Clubs", "King"], 
	["Spades", "Ace"], ["Spades", 2], ["Spades", 3], ["Spades", 4], 
	["Spades", 5], ["Spades", 6], ["Spades", 7], ["Spades", 8], 
	["Spades", 9], ["Spades", 10], ["Spades", "Jack"], 
	["Spades", "Queen"], ["Spades", "King"]
]

#actual deck used in round, value set only on scene load, changed later
var deck = standard_deck
#dealer's hand of cards
var dealer_hand : Array = []
#how much the cards value
var dealer_hand_value : int = 0

#reference for the clients
var players : Array = []
var whoseturn : int = -1

func _ready() -> void:
	#adds 3 to 5 players
	for players_to_add in randi_range(3, 5):
		var player_inst = new_player.instantiate()
		player_inst._decide_personality()
		players.append(player_inst)
		player_side.add_child(player_inst)

func _process(delta: float) -> void:
	#if dealer has less than 17, hit, else stand
	if dealer_hand_value < 17:
		$hit.disabled = false
		$stand.disabled = true
	else:
		$hit.disabled = true
		$stand.disabled = false

#shuffles deck (just for better readability lol)
func _shuffle_deck():
	deck.shuffle()

#picking a random card, used in functions as a callable
func _pick_random_card():
	#picks a card
	var random_card = deck.pop_at(randi_range(0, deck.size() - 1))
	#if there is a card
	if random_card != null:
		#example: Jack of Hearts
		print(str(random_card[1]) + " of " + random_card[0])
		#returns the card for the function
		return random_card
	#if there is no card
	else:
		#call the player stupid
		print("No more cards in deck!")
		#this never happened idk what it does
		return null

#calculating the hand scores for each player
func _calculate_hand_value(who):
	#777 is dealer (idk why "Dealer" isnt allowed)
	if who == 777:
		#value bank is a bandaid-fix for the for loop messing w the score
		#without this every loop recounts itself
		#example: 6 + 10 would be 22 (6 + (6 + 10))
		var value_bank : int
		#on every card on the dealer's hand
		for card in dealer_hand.size():
			#if it's not a string
			#(yes you can do this, yes 4 is string)
			if typeof(dealer_hand[card][1]) != 4:
				#adds the card value to dealer's hand score
				value_bank += dealer_hand[card][1]
			#if it's a string, and an ace
			elif dealer_hand[card][1] == "Ace":
				#add 11
				value_bank += 11
			#if it's a string, and either King, Queen or Jack
			else:
				#add 10
				value_bank += 10
		#updates the dealer's score
		dealer_hand_value = value_bank
	else:
		var value_bank : int
		#on every card on (a player's) hand
		for card in players[who].hand.size():
			if typeof(players[who].hand[card][1]) != 4:
				value_bank += players[who].hand[card][1]
			elif players[who].hand[card][1] == "Ace":
				value_bank += 11
			else:
				value_bank += 10
		players[who].hand_value = value_bank

#adds a card for the dealer, then updates score
func _dealer_add_card():
	dealer_hand.append(deck.pop_front())
	_calculate_hand_value(777)

#adds a card for (a player), then updates score
func _player_add_card(player):
	players[player].hand.append(deck.pop_front())
	_calculate_hand_value(player)

#distributes cards for everyone (after checking for size)
#called two times
#used in round beginning
func _distribute_cards():
	if dealer_hand.size() < 2:
		_dealer_add_card()
	for player_count in players.size():
		if players[player_count].hand.size() < 2:
			_player_add_card(player_count)
	player_action.start()

#puts cards in deck and resets scores
func _reset_cards():
	for card in dealer_hand.size():
		deck.append(dealer_hand.pop_front())
		dealer_hand_value = 0
	for player in players.size():
		for card in players[player].hand.size():
			deck.append(players[player].hand.pop_front())
		players[player].hand_value = 0

#dealer hits
func _dealer_hit():
	_dealer_add_card()

#dealer stands
func _dealer_stand():
	pass






#button functions
func _on_shuffle_button_up() -> void:
	_shuffle_deck()

func _on_pick_button_up() -> void:
	print(_pick_random_card())

func _on_distribute_button_up() -> void:
	_distribute_cards()
	_distribute_cards()

func _on_reset_button_up() -> void:
	_reset_cards()

func _on_hit_button_up() -> void:
	_dealer_hit()

func _on_stand_button_up() -> void:
	_dealer_stand()

func _on_player_action_timeout() -> void:
	if whoseturn + 1 <= players.size() - 1:
		whoseturn += 1
		print("It's player " + str(whoseturn) + "'s turn!")
	else:
		whoseturn = 0
		print("It's player " + str(whoseturn) + "'s turn!")
