extends Node3D

@onready var npc = preload("res://Scenes/blackjack_npc.tscn")
@onready var card = preload("res://Scenes/card.tscn")
@onready var gold = preload("res://Scenes/gold_nugget.tscn")
@onready var table_node = $Mesa_blackjack
@onready var deck_node: Node3D = $deck
#@onready var gamecontrol: Panel = $CanvasLayer/gamecontrol
@onready var player: CharacterBody3D = $blackjack_player
@onready var card_distr_timer: Timer = $card_distr_timer
@onready var turn_timer: Timer = $turn_timer
@onready var revealed_card: Panel = $CanvasLayer/revealed_card
@onready var revealed_info: TextureRect = $CanvasLayer/revealed_card/card/info
@onready var revealed_text: Label = $CanvasLayer/revealed_card/text
@onready var blackjack_ui_test: Control = $CanvasLayer/Blackjack_UI_test
@onready var end_ui: CanvasLayer = $blackjack_end_ui
@onready var hand_markers: Node3D = $hand_markers

var tween : Tween

var table := []
var bets_on_table := false
var round_started := false
var distribution_number : float = 0.0
var distributed_cards := false
var round : int = 0
var playing_npcs := []
#var gc_labels : Array = []
var round_order_npcs := []
var whose_turn : int = 0
var dealer_revealed_card : Node3D
var dealer_can_hit := false
var dealer_can_stand := false
var dealer_busted := false
var dealer_blackjacked := false
var hand_marker_array := []

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

var rank_order := ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"]
var value_order := ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]

var deck = []
var shuffler_deck = []

func _ready():
	player.intro_tweens()
	instantiate_cards()
	##adds a new chair in the table array for referencing positions
	for chairs in table_node.get_child_count():
		##excludes the table mesh from chair count
		if table_node.get_child(chairs) is Marker3D:
			##chair is [position, is_taken]
			table.append([table_node.get_child(chairs).global_position, 0])
	for markers in hand_markers.get_children():
		hand_marker_array.append(markers)
	for sitting_npcs in Globals.transiting_characters_to_gamble:
		spawn_player(sitting_npcs[0], sitting_npcs[1])
	await get_tree().create_timer(0.5).timeout
	MusicPlayer.blackjacktheme.play()
##putting the cards in the screen
func instantiate_cards():
	for instance in 52:
		#print("Card number " + str(instance))
		##adds a new card instance
		var new_card = card.instantiate()
		##to the deck
		deck.push_back(new_card)
		##puts each card slightly above the previous (stacking deck)
		new_card.position.y = float(deck.find(new_card)) / 524
		##each card upside down
		new_card.rotation_degrees.x = 180
		new_card.name = "card" + str(instance)
		##every card is based on the standard deck, each suit and rank
		new_card.chosen_suit = standard_deck[instance][0]
		new_card.chosen_rank = standard_deck[instance][1]
		new_card.chosen_value = standard_deck[instance][2]
		deck_node.add_child(new_card)
	shuffle_deck()

##calls an npc (currently instantiating a new one) to a chair
func call_player():
	if playing_npcs.size() + 1 != 6:
		var new_npc = npc.instantiate()
		##choosing the personality (change on implementation)
		var personality_picker = randi_range(1, 5)
		match personality_picker:
			1:
				new_npc.personality = "Pleb"
				new_npc.money = randi_range(1, 3) * 100
			2:
				new_npc.personality = "Mage"
				new_npc.money = randi_range(2, 5) * 100
			3:
				new_npc.personality = "Guard"
				new_npc.money = randi_range(3, 5) * 100
			4:
				new_npc.personality = "Noble"
				new_npc.money = randi_range(5, 7) * 100
			5:
				new_npc.personality = "Joker"
				new_npc.money = randi_range(1, 3) * 1000
		##instantiate new npc away from table (visual effect for testing)
		new_npc.global_position = Vector3(randf_range(-3, 3), 0.342, -6)
		add_child(new_npc)
		##checking if each chair is taken
		for chairs in table.size():
			##if it isn't (free chair)
			if table[chairs][1] == 0 and !new_npc.assigned_chair:
				##call the funcion on the npc script to come to the chair
				new_npc.go_to_table(table[chairs][0])
				print(table[chairs][0])
				##occupy the chair
				table[chairs][1] = 1
				new_npc.assigned_chair = true
				new_npc.name = str(chairs)
				new_npc.hand_marker = hand_marker_array[chairs]
				##add the npc to the npc array
				playing_npcs.append(new_npc)
				print(new_npc)

func spawn_player(pers, money):
	var new_npc = npc.instantiate()
	##choosing the personality 
	new_npc.personality = pers
	new_npc.money = money
	add_child(new_npc)
	##checking if each chair is taken
	for chairs in table.size():
		##if it isn't (free chair)
		if table[chairs][1] == 0 and !new_npc.assigned_chair:
			new_npc.global_position = table[chairs][0]
			new_npc.look_at_player()
			##occupy the chair
			table[chairs][1] = 1
			new_npc.assigned_chair = true
			new_npc.name = str(chairs)
			new_npc.hand_marker = hand_marker_array[chairs]
			##add the npc to the npc array
			playing_npcs.append(new_npc)
			print(new_npc)

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
			round_order_npcs.append(playing_npcs[1])
			round_order_npcs.append(playing_npcs[0])
			round_order_npcs.append(playing_npcs[2])
			round_order_npcs.append(playing_npcs[3])
		5:
			round_order_npcs.append(playing_npcs[4])
			round_order_npcs.append(playing_npcs[1])
			round_order_npcs.append(playing_npcs[0])
			round_order_npcs.append(playing_npcs[2])
			round_order_npcs.append(playing_npcs[3])

func shuffle_deck():
	for card in deck.size():
		##picks a random card
		var in_shuffle_hand = deck.pick_random()
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
		card.position.y = float(deck.find(card)) / 524

##animation for card distributing
func distribute_cards():
	##increases a number 
	distribution_number += 1
	
	##defines how many cards need to be distributed
	##two for every npc + two for dealer
	var cards_to_distribute : int = round_order_npcs.size() * 2 + 2
	
	##every third (number) is a break in the animation
	if distribution_number / 3 - floor(distribution_number / 3) == 0:
		pass
	##every first (number) gives a card
	elif int(distribution_number - 1) % 3 == 0:
		##the dealer's first card is side down
		if distribution_number / 3 > round_order_npcs.size():
			##gives the top card to the dealer
			card_to_dealer(deck.pop_back(), Vector3(0.40, 0, 0), Vector3(180, 0, 0))
		else:
		##the npc's first and second cards are identical
			##gives the top card to the npc
			card_to_npc(deck.pop_back(), round_order_npcs[int(floor(distribution_number / 3))], Vector3(0, 0, 0))
	else:
		##the dealer's first card is side up
		if distribution_number / 3 > round_order_npcs.size():
			##gives the top card to the dealer
			card_to_dealer(deck.pop_back(), Vector3(0.40, 0, 0), Vector3.ZERO)
		else:
		##the npc's first and second cards are identical
			##gives the top card to the npc
			card_to_npc(deck.pop_back(), round_order_npcs[int(floor(distribution_number / 3))], Vector3(0, 0, 0))

##tween to send a card to the dealer
func card_to_dealer(card : Node3D, pos : Vector3, rot : Vector3):
	player.dealer_hand.append(card)
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	##with a little horizontal and vertical separation
	tween.tween_property(card, "position", pos + Vector3(float(player.dealer_hand.size()) / 20,\
	float(player.dealer_hand.find(card)) / 512, 0), 1)
	##makes it rotate to where it is supposed to
	tween.tween_property(card, "rotation_degrees", rot, 0.66)
	player.calculate_hand_value()
	#player.update_gc_label()

##tween to send a card to an npc
func card_to_npc(card : Node3D, who : CharacterBody3D, rot : Vector3):
	who.hand.append(card)
	card.reparent(who.hand_marker)
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(card, "position", Vector3(float(who.hand.size()) / 25, float(who.hand.size()) / 512, 0), 1)
	#tween.tween_property(card, "global_position", who.hand_marker.global_position + Vector3(float(who.hand.size()) / 25,\
	#float(who.hand.size()) / 512, 0), 1)
	tween.tween_property(card, "rotation_degrees", rot, 0.66)
	##updates the game control label
	who.calculate_hand_value()
	#who.update_gc_label()

func pass_turn():
	turn_timer.start()
	round += 1

func place_bets():
	bets_on_table = true
	for npcs in playing_npcs:
		##placing a bet should be 10%, 20% or 30% of current money
		npcs.bet = npcs.money * (randi_range(1, 3) * 10) / 100
		var inst = gold.instantiate()
		inst.global_position.z -= 0.2
		inst.scale = Vector3(0.1, 0.1, 0.1)
		
		if npcs.bet > 10:
			inst.scale = Vector3.ONE * (0.1 + npcs.bet / 2500.0)

		inst.get_child(1).text = str(npcs.bet) + " Gold"
		npcs.hand_marker.add_child(inst)

func start_game():
	if !bets_on_table:
		place_bets()
		blackjack_ui_test.f.get_child(1).text = "Distribute Cards"
	elif !round_started and playing_npcs.size() > 1:
		round_started = true
		set_round_order()
		$card_distr_timer.start()
		blackjack_ui_test.f.get_child(1).text = "Start Game"

func dealer_turn():
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	##makes it rotate to where it is supposed to
	tween.tween_property(player.dealer_hand[0], "rotation_degrees", Vector3.ZERO, 0.66)
	dealer_can_stand = true
	dealer_can_hit = true

func dealer_hit():
	card_to_dealer(deck.pop_back(), Vector3(0.40, 0, 0), Vector3.ZERO)

func dealer_stand():
	end_game()

func dealer_bust():
	print("Dealer busted")
	dealer_busted = true
	end_game()

func dealer_blackjack():
	print("Dealer blackjack")
	dealer_blackjacked = true

func end_game():
	MusicPlayer.blackjacktheme.stop()
	MusicPlayer.greensleeves.play()
	for npcs in round_order_npcs:
		if npcs.state == "Doubled":
			tween = create_tween()
			tween.set_trans(Tween.TRANS_QUART)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(npcs.hand[2], "rotation_degrees", Vector3.ZERO, 0.66)
	dealer_can_stand = false
	dealer_can_hit = false
	print("Game ended")
	if dealer_busted:
		for npcs in round_order_npcs:
			match npcs.state:
				"Standed":
					print(npcs.name + " has won!")
					end_ui.result_texts([npcs.name, "Win", npcs.bet, "+" + str(npcs.bet)])
					##return money bet + how much was bet (2x bet)
				"Busted":
					print(npcs. name + " had busted and lost!")
					end_ui.result_texts([npcs.name, "Loss", npcs.bet, "-" + str(npcs.bet)])
					##lose the money bet
				"Doubled":
					print(npcs.name + " has won with a double down!")
					end_ui.result_texts([npcs.name, "Double Win", npcs.bet, "+" + str(npcs.bet * 2)])
					##return doubled bet + how much the bet valued in total (4x bet)
				"Blackjack":
					print(npcs.name + " has a blackjack and won!")
					end_ui.result_texts([npcs.name, "Blackjack", npcs.bet, "+" + str(int(npcs.bet * 2.5))])
					##return bet + bet + half bet (2.5x bet)
	elif dealer_blackjacked:
		print("The dealer has a blackjack!")
		for npcs in round_order_npcs:
			if npcs.state == "Blackjack":
				print(npcs.name + " also has a blackjack and gets a push back.")
				end_ui.result_texts([npcs.name, "Tie", npcs.bet, 0])
			else:
				print(npcs.name + " either bust or didn't have a blackjack. Either way they lost.")
				end_ui.result_texts([npcs.name, "Loss", npcs.bet, "-" + str(npcs.bet)])
	else:
		for npcs in round_order_npcs:
			match npcs.state:
						"Standed":
							if npcs.hand_value > player.dealer_hand_value:
								print(npcs.name + " standed and won!")
								end_ui.result_texts([npcs.name, "Win", npcs.bet, "+" + str(npcs.bet)])
								##return money bet + how much was bet (2x bet)
							elif npcs.hand_value == player.dealer_hand_value:
								print(npcs.name + " tied the dealer and gets a push back.")
								end_ui.result_texts([npcs.name, "Tie", npcs.bet, 0])
								##return money bet
							else:
								print(npcs.name + " standed and lost!")
								end_ui.result_texts([npcs.name, "Loss", npcs.bet, "-" + str(npcs.bet)])
								##lose the money bet
						"Busted":
							print(npcs. name + " had busted and lost!")
							end_ui.result_texts([npcs.name, "Loss", npcs.bet, "-" + str(npcs.bet)])
							##lose the money bet
						"Doubled":
							if npcs.hand_value > player.dealer_hand_value:
								print(npcs.name + " has won with a double down!")
								end_ui.result_texts([npcs.name, "Double Win", npcs.bet, "+" + str(npcs.bet * 2)])
								##return doubled bet + how much the bet valued in total (4x bet)
							elif npcs.hand_value == player.dealer_hand_value:
								print(npcs.name + " tied the dealer and gets a push back.")
								end_ui.result_texts([npcs.name, "Tie", npcs.bet, 0])
								##return money bet
							else:
								print(npcs.name + " doubled down and lost!")
								end_ui.result_texts([npcs.name, "Double Loss", npcs.bet, "-" + str(npcs.bet * 2)])
								##lose the money bet
						"Blackjack":
							print(npcs.name + " has a blackjack and won!")
							end_ui.result_texts([npcs.name, "Blackjack", npcs.bet, "+" + str(int(npcs.bet * 2.5))])
							##return bet + bet + half bet (2.5x bet)
	end_anim()

func end_anim():
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(end_ui, "offset", Vector2.ZERO, 2.5)
	await get_tree().create_timer(2.5).timeout
	end_ui.match_end_anim()

func spell_cast(spell : String):
	if Globals.check_spell_available(spell):
		Globals.cooldown_spell(spell)
		var spell_worked = randi_range(1, 4)
		if spell_worked == 4:
			match spell:
				"Providence":
					failed_providence()
				"Philo Shard":
					failed_philo_shard()
				"Fools Gold":
					failed_fools_gold()
		else:
			match spell:
				"Providence":
					providence()
				"Philo Shard":
					philo_shard()
				"Fools Gold":
					fools_gold()
	end_ui.visible = true
	end_ui.match_end_anim()

func providence():
	dealer_revealed_card = deck.back()
	if !revealed_card.visible:
		revealed_card.visible = true
		tween = create_tween()
		tween.set_trans(Tween.TRANS_QUART)
		tween.set_ease(Tween.EASE_OUT)
		tween.set_parallel(true)
		tween.tween_property(revealed_card, "position", Vector2(998, 266), 1)
	revealed_info.set_texture(load("res://Assets/card_textures/" + str(dealer_revealed_card.rank.to_lower()) +"_of_" + str(dealer_revealed_card.suit.to_lower()) + ".png"))
	revealed_text.text = str(dealer_revealed_card.rank) +" of " + str(dealer_revealed_card.suit)

func failed_providence():
	dealer_revealed_card = deck[randi_range(0, deck.size() - 2)]
	if !revealed_card.visible:
		revealed_card.visible = true
		tween = create_tween()
		tween.set_trans(Tween.TRANS_QUART)
		tween.set_ease(Tween.EASE_OUT)
		tween.set_parallel(true)
		tween.tween_property(revealed_card, "position", Vector2(998, 266), 1)
	revealed_info.set_texture(load("res://Assets/card_textures/" + str(dealer_revealed_card.rank.to_lower()) +"_of_" + str(dealer_revealed_card.suit.to_lower()) + ".png"))
	revealed_text.text = str(dealer_revealed_card.rank) +" of " + str(dealer_revealed_card.suit) + "?"

func philo_shard():
	match deck.back().value:
		"A":
			deck.back().change_values("Two", deck.back().suit, "2")
		"J":
			deck.back().change_values("Queen", deck.back().suit, "Q")
		"Q":
			deck.back().change_values("King", deck.back().suit, "K")
		"K":
			deck.back().change_values("Ace", deck.back().suit, "A")
		_:
			deck.back().change_values(rank_order[int(deck.back().value)], deck.back().suit, value_order[int(deck.back().value)])
	if dealer_revealed_card != null:
		providence()

func failed_philo_shard():
	var what_rank = randi_range(0, 12)
	deck.back().change_values(rank_order[what_rank], deck.back().suit, value_order[what_rank])
	if dealer_revealed_card != null:
		spell_cast("Providence")

func fools_gold():
	match deck.back().value:
		"A":
			deck.back().change_values("King", deck.back().suit, "K")
		"J":
			deck.back().change_values("Ten", deck.back().suit, "10")
		"Q":
			deck.back().change_values("Jack", deck.back().suit, "J")
		"K":
			deck.back().change_values("Queen", deck.back().suit, "Q")
		_:
			deck.back().change_values(rank_order[int(deck.back().value) - 2], deck.back().suit, value_order[int(deck.back().value) - 2])
	if dealer_revealed_card != null:
		providence()

func failed_fools_gold():
	var what_rank = randi_range(0, 12)
	deck.back().change_values(rank_order[what_rank], deck.back().suit, value_order[what_rank])
	if dealer_revealed_card != null:
		spell_cast("Providence")

func _on_card_distr_timer_timeout() -> void:
	##if still distributing cards
	if distribution_number < (round_order_npcs.size() + 1) * 3:
		distribute_cards()
	else:
		distributed_cards = true
		blackjack_ui_test.f.modulate = Color.WHITE
		card_distr_timer.stop()

func _on_turn_timer_timeout() -> void:
	var npcs_playing = round_order_npcs.size()
	
	for npcs in round_order_npcs:
		if npcs.state != "Playing":
			npcs_playing -= 1
	
	if npcs_playing > 0:
		if round_order_npcs[whose_turn].state == "Playing":
			round_order_npcs[whose_turn].play_turn()
		if whose_turn + 1 == round_order_npcs.size():
			whose_turn = 0
		else:
			whose_turn += 1
		turn_timer.start()
		round += 1
	else:
		turn_timer.stop()
		whose_turn = -1
		dealer_turn()
