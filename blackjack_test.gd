extends Control

#TO-DO
#regras mudaveis (focar agora em H17, 1 deck, hole card, late surrender, 
#no split aces, only same split, resplit to 4, no double-split, reno, 3:2 bonus)

#TO-DO NO JOGO REAL
#hole card do dealer

@onready var player_side: HBoxContainer = $players/HBoxContainer
@onready var new_npc = preload("res://bj_npc_test.tscn")
@onready var player_action: Timer = $player_action

#standard deck for shuffling a new deck
var standard_deck : Array = [
	["Hearts", "Ace"], ["Hearts", "2"], ["Hearts", "3"], ["Hearts", "4"], 
	["Hearts", "5"], ["Hearts", "6"], ["Hearts", "7"], ["Hearts", "8"], 
	["Hearts", "9"], ["Hearts", "10"], ["Hearts", "Jack"], 
	["Hearts", "Queen"], ["Hearts", "King"], 
	["Diamonds", "Ace"], ["Diamonds", "2"], ["Diamonds", "3"], ["Diamonds", "4"], 
	["Diamonds", "5"], ["Diamonds", "6"], ["Diamonds", "7"], ["Diamonds", "8"], 
	["Diamonds", "9"], ["Diamonds", "10"], ["Diamonds", "Jack"], 
	["Diamonds", "Queen"], ["Diamonds", "King"],
	["Clubs", "Ace"], ["Clubs", "2"], ["Clubs", "3"], ["Clubs", "4"], 
	["Clubs", "5"], ["Clubs", "6"], ["Clubs", "7"], ["Clubs", "8"], 
	["Clubs", "9"], ["Clubs", "10"], ["Clubs", "Jack"], 
	["Clubs", "Queen"], ["Clubs", "King"], 
	["Spades", "Ace"], ["Spades", "2"], ["Spades", "3"], ["Spades", "4"], 
	["Spades", "5"], ["Spades", "6"], ["Spades", "7"], ["Spades", "8"], 
	["Spades", "9"], ["Spades", "10"], ["Spades", "Jack"], 
	["Spades", "Queen"], ["Spades", "King"]
]

#actual deck used in round, value set only on scene load, changed later
var deck = standard_deck
#dealer's hand of cards
var dealer_hand : Array = []
#how much the cards value
var dealer_hand_value : int = 0
var dealer_busted = false
var dealer_blackjack = false

#reference for the clients
var players : Array = []
var whoseturn : int = -1
var someone_still_playing = false
var resplit_to : int = 4

func _ready() -> void:
	#adds 3 to 5 players
	for players_to_add in randi_range(3, 5):
		var player_inst = new_npc.instantiate()
		player_inst._decide_personality()
		player_inst.name = "Player " + str(players.size())
		players.append(player_inst)
		player_side.add_child(player_inst)
	_shuffle_deck()

func _process(delta: float) -> void:
	#if dealer has less than 17, hit, else stand
	if whoseturn != -1:
		if dealer_hand_value < 17 and someone_still_playing == false:
			$hit.disabled = false
			$stand.disabled = true
		elif dealer_hand_value >= 17 and someone_still_playing == false:
			$hit.disabled = true
			$stand.disabled = false
		else:
			$hit.disabled = true
			$stand.disabled = true
	else:
		$hit.disabled = true
		$stand.disabled = true

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
		print(random_card[1] + " of " + random_card[0])
		#returns the card for the function
		return random_card
	#if there is no card
	else:
		#call the player stupid
		print("No more cards in deck!")
		#this never happened idk what it does
		return null

#calculating the hand scores for each player
func _calculate_hand_value(who, whathand):
	#if player is not an object (the dealer is not)
	if typeof(who) != 24:
		#value bank is a bandaid-fix for the for loop messing w the score
		#without this every loop recounts itself
		#example: 6 + 10 would be 22 (6 + (6 + 10))
		var value_bank : int
		#on every card on the dealer's hand
		for card in dealer_hand.size():
			#adds 11 to aces
			if dealer_hand[card][1] == "Ace":
				value_bank += 11
			#10 to face cards
			elif dealer_hand[card][1] == "King" or \
			dealer_hand[card][1] == "Queen" or \
			dealer_hand[card][1] == "Jack":
				value_bank += 10
			#and numbers to numbers
			else:
				value_bank += str_to_var(dealer_hand[card][1])
		#updates the dealer's score
		dealer_hand_value = value_bank
		var has_ace : bool
		var has_ten_value : bool
		for card in dealer_hand.size():
			if dealer_hand[card].has("Ace"):
				has_ace = true
			if dealer_hand[card].has("10") or dealer_hand[card].has("Jack") or \
			dealer_hand[card].has("Queen") or dealer_hand[card].has("King"):
				has_ten_value = true
			if has_ace and has_ten_value:
				dealer_blackjack == true
				if whoseturn != -1:
					print("Dealer's got a blackjack!")
		if dealer_hand_value >= 22 and whoseturn != -1:
			dealer_busted = true
			print("Dealer has busted! Common casino L")
			_end_game()
		elif dealer_hand_value >= 22 and whoseturn == -1:
			print("Dealer busted at first round, replace card")
			deck.append(dealer_hand.pop_back())
			_dealer_add_card("Dealer")
	else:
		var value_bank : int
		#on every card on (a player's) hand
		for card in who.hands[whathand].size():
			if who.hands[whathand][card][1] == "Ace":
				value_bank += 11
			elif who.hands[whathand][card][1] == "King" or \
			who.hands[whathand][card][1] == "Queen" or \
			who.hands[whathand][card][1] == "Jack":
				value_bank += 10
			else:
				value_bank += str_to_var(who.hands[whathand][card][1])
		who.hand_values[whathand] = value_bank
		if who.hand_values[whathand] >= 22:
			var aces_in_hand = 0
			for card in who.hands[whathand].size():
				if who.hands[whathand][card][1] == "Ace":
					aces_in_hand += 1
			if aces_in_hand >= 2:
				value_bank -= 10
				who.hand_values[whathand] = value_bank
			else:
				who._bust(who.hands[whathand])

#adds a card for the dealer, then updates score
func _dealer_add_card(dealer):
	dealer_hand.append(deck.pop_front())
	_calculate_hand_value(dealer, 0)

#adds a card for (a player), then updates score
func _player_add_card(player, whathand):
	player.hands[whathand].append(deck.pop_front())
	_calculate_hand_value(player, 0)

#func _player_add_card2(player):
	#player.hand1.append(deck.pop_front())
	#_calculate_hand_value(player, 1)
#
#func _player_add_card3(player):
	#player.hand2.append(deck.pop_front())
	#_calculate_hand_value(player, 2)
#
#func _player_add_card4(player):
	#player.hand3.append(deck.pop_front())
	#_calculate_hand_value(player, 3)

#distributes cards for everyone (after checking for size)
#called two times
#used in round beginning
func _distribute_cards():
	if dealer_hand.size() < 2:
		_dealer_add_card("Dealer")
	for player_count in players.size():
		if players[player_count].hand0.size() < 2:
			_player_add_card(players[player_count], 0)
	player_action.start()

#puts cards in deck and resets scores
func _reset_cards():
	for card in dealer_hand.size():
		deck.append(dealer_hand.pop_front())
		dealer_hand_value = 0
	#for player in players.size():
		#for card in players[player].hand.size():
			#deck.append(players[player].hand.pop_front())
		#players[player].hand0_value = 0
		#players[player].standed = false
		#players[player].busted = false
		#players[player].blackjack_in_hand = false 
		#players[player].doubled_down = false
		#players[player].surrendered = false
		whoseturn = -1

#dealer hits
func _dealer_hit():
	_dealer_add_card("Dealer")

#dealer stands
func _dealer_stand():
	_calculate_hand_value("Dealer", 0)
	_end_game()

func _end_game():
	print("Game ending. Results:\n")
	print("Dealer hand value: " + str(dealer_hand_value))
	if dealer_busted == true:
		for i in players.size():
			if players[i].busted != true and players[i].surrendered != true:
				print("Line 227 says " + players[i].name + " is a winner!")
			elif players[i].busted == true:
				print("Line 229 says " + players[i].name + " busted and lost.")
			elif players[i].surrendered == true:
				print("Line 231 says " + players[i].name + " had already surrendered.")
	else:
		if dealer_blackjack == false:
			for i in players.size():
				if players[i].hand0_value > dealer_hand_value and \
				players[i].busted != true and players[i].surrendered != true and \
				players[i].doubled_down == true:
					print("Line 238 says " + players[i].name + " doubled down and won!")
				elif players[i].hand0_value > dealer_hand_value and \
				players[i].busted != true and players[i].surrendered != true and \
				players[i].doubled_down == false:
					print("Line 242 says " + players[i].name + " is a winner!")
				elif players[i].hand0_value <= dealer_hand_value and \
				players[i].busted != true and players[i].surrendered != true:
					print("Line 245 says " + players[i].name + " is a loser.")
				elif players[i].busted == true:
					print("Line 247 says " + players[i].name + " busted and lost.")
				elif players[i].surrendered == true:
					print("Line 249 says " + players[i].name + " had already surrendered.")
		else:
			for i in players.size():
				if players[i].blackjack_in_hand == true and \
				players[i].busted != true and players[i].surrendered != true:
					print("Line 254 says " + players[i].name + " is pushed.")
				elif players[i].blackjack_in_hand == false and \
				players[i].busted != true and players[i].surrendered != true:
					print("Line 257 says " + players[i].name + " is a loser.")
				elif players[i].busted == true:
					print("Line 259 says " + players[i].name + " busted and lost.")
				elif players[i].surrendered == true:
					print("Line 261 says " + players[i].name + " had already surrendered.")

func _pass_turn():
	someone_still_playing = false
	for i in players.size():
		if players[i].playing == true:
			someone_still_playing = true
	if someone_still_playing == true:
		if whoseturn + 1 <= players.size() - 1:
			whoseturn += 1
			print("It's player " + str(whoseturn) + "'s turn!")
		else:
			whoseturn = 0
			print("It's player " + str(whoseturn) + "'s turn!")
		players[whoseturn]._act(players[whoseturn].hand0, \
		players[whoseturn].hand0_value, players[whoseturn].hand0_state)
		if players[whoseturn].hand1.is_empty() == false:
			players[whoseturn]._act(players[whoseturn].hand1, \
		players[whoseturn].hand1_value, players[whoseturn].hand1_state)
		if players[whoseturn].hand2.is_empty() == false:
			players[whoseturn]._act(players[whoseturn].hand2, \
		players[whoseturn].hand2_value, players[whoseturn].hand2_state)
		if players[whoseturn].hand3.is_empty() == false:
			players[whoseturn]._act(players[whoseturn].hand3, \
		players[whoseturn].hand3_value, players[whoseturn].hand3_state)
	else:
		print("It's the dealer's turn!")

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
	_pass_turn()

func _on_pass_button_up() -> void:
	_pass_turn()
