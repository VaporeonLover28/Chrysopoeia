extends CharacterBody3D

@onready var nav: NavigationAgent3D = $nav
@onready var hand_marker: Marker3D = $hand
@onready var action_label: Label3D = $action_label
@onready var game: Node3D = $".."
@onready var player: CharacterBody3D = $"../bj_player_test"

@export_enum("Pleb", "Mage", "Guard", "Noble", "Joker" ) var personality : String = "Noble"
@export_enum("Playing", "Standed", "Busted", "Blackjack", "Doubled") var state : String = "Playing"

var assigned_chair : bool = false
var is_sat_down : bool = false

var assigned_gc_label : RichTextLabel
var hand : Array = []
var hand_value : int = 0
var aces_in_hand = 0

func _process(delta: float) -> void:
	if is_sat_down == false:
		var destination = nav.get_next_path_position()
		var local_destination = destination - global_position
		var dir = local_destination.normalized()
		velocity = dir * 4
		look_at(transform.basis.z * -1)
		rotation.x = 0
		rotation.z = 0
	elif velocity != Vector3.ZERO:
		velocity = Vector3.ZERO
		#_look_at_player()
	move_and_slide()

func play_turn():
	calculate_hand_value()
	print(name + "'s turn ")
	if state == "Playing":
		match personality:
			"Noble":
				if aces_in_hand == 0:
					match player.dealer_hand[1].value:
						"2":
							hard_total_matrix(
							"stand",\
							"stand",\
							"stand",\
							"stand",\
							"stand",\
							"hit",\
							"double_down",\
							"double_down",\
							"hit",\
							"hit")
						"3":
							hard_total_matrix(
							"stand",\
							"stand",\
							"stand",\
							"stand",\
							"stand",\
							"hit",\
							"double_down",\
							"double_down",\
							"double_down",\
							"hit")
						"4", "5", "6":
							hard_total_matrix(
							"stand",\
							"stand",\
							"stand",\
							"stand",\
							"stand",\
							"stand",\
							"double_down",\
							"double_down",\
							"double_down",\
							"hit")
						"7", "8", "9":
							hard_total_matrix(
							"stand",\
							"stand",\
							"hit",\
							"hit",\
							"hit",\
							"hit",\
							"double_down",\
							"double_down",\
							"hit",\
							"hit")
						"10", "J", "Q", "K", "A":
							hard_total_matrix(
							"stand",\
							"stand",\
							"hit",\
							"hit",\
							"hit",\
							"hit",\
							"double_down",\
							"hit",\
							"hit",\
							"hit")
				else:
					match player.dealer_hand[1].value:
						"2":
							soft_total_matrix(
							"stand",\
							"stand",\
							"double_down",\
							"hit",\
							"hit",\
							"hit",\
							"hit")
						"3":
							soft_total_matrix(
							"stand",\
							"stand",\
							"double_down",\
							"double_down",\
							"hit",\
							"hit",\
							"hit")
						"4":
							soft_total_matrix(
							"stand",\
							"stand",\
							"double_down",\
							"double_down",\
							"double_down",\
							"hit",\
							"hit")
						"5":
							soft_total_matrix(
							"stand",\
							"stand",\
							"double_down",\
							"double_down",\
							"double_down",\
							"double_down",\
							"hit")
						"6":
							soft_total_matrix(
							"stand",\
							"double_down",\
							"double_down",\
							"double_down",\
							"double_down",\
							"double_down",\
							"double_down")
						"7", "8":
							soft_total_matrix(
							"stand",\
							"stand",\
							"stand",\
							"hit",\
							"hit",\
							"hit",\
							"hit")
						"9", "10", "J", "Q", "K", "A":
							soft_total_matrix(
							"stand",\
							"stand",\
							"hit",\
							"hit",\
							"hit",\
							"hit",\
							"hit")
	else:
		match state:
			"Standed":
				print(name + " has standed, skipping turn.")
			"Busted":
				print(name + " has busted, skipping turn.")
			"Blackjack":
				print(name + " has a blackjack, so they stand.")
			"Doubled":
				print(name + " has doubled, so they cannot hit.")

func calculate_hand_value():
	var value_bank = 0
	aces_in_hand = 0
	
	for card in hand:
		match card.value:
			"A":
				value_bank += 11
				aces_in_hand += 1
			"2", "3", "4", "5", "6", "7", "8", "9", "10":
				value_bank += int(card.value)
			"J", "Q", "K":
				value_bank += 10
	
	if value_bank > 21:
		if aces_in_hand > 0 and value_bank - 10 < 22:
			value_bank -= 10
		elif aces_in_hand > 1 and value_bank - 20 < 22 and value_bank - 10 > 22:
			value_bank -= 20
		elif aces_in_hand > 1 and value_bank - 20 < 22 and value_bank - 10 < 22:
			value_bank -= 10
		else:
			bust()
	
	if value_bank == 21 and hand.size() == 2 and aces_in_hand == 1:
		blackjack()
	
	hand_value = value_bank
	update_gc_label()

func hit():
	update_action_label("hit")
	print(name + " hits.")
	game.card_to_npc(game.deck.pop_back(), self, Vector3.ZERO)
	calculate_hand_value()

func stand():
	update_action_label("stand")
	state = "Standed"
	print(name + " stands.")

func double_down():
	update_action_label("double")
	state = "Doubled"
	print(name + " doubles down.")
	game.card_to_npc(game.deck.pop_back(), self, Vector3(-180, 90, 0))
	calculate_hand_value()

func bust():
	update_action_label("bust")
	state = "Busted"
	print(name + " busts.")

func blackjack():
	update_action_label("blackjack")
	state = "Blackjack"
	print(name + " has a blackjack.")

func hard_total_matrix(case1, case2, case3, case4, case5, case6, case7, case8, case9, case10):
	match hand_value:
		21, 20, 19, 18:
			case_match(case1)
		17:
			case_match(case2)
		16:
			case_match(case3)
		15:
			case_match(case4)
		14, 13:
			case_match(case5)
		12:
			case_match(case6)
		11:
			case_match(case7)
		10:
			case_match(case8)
		9:
			case_match(case9)
		8, 7, 6, 5, 4:
			case_match(case10)

func soft_total_matrix(case1, case2, case3, case4, case5, case6, case7):
	match hand_value:
		20:
			case_match(case1)
		19:
			case_match(case2)
		18:
			case_match(case3)
		17:
			case_match(case4)
		16, 15:
			case_match(case5)
		14, 13:
			case_match(case6)
		12:
			case_match(case7)

func case_match(case):
	match case:
		"hit":
			hit()
		"stand":
			stand()
		"double_down":
			double_down()

func update_gc_label():
	assigned_gc_label.text = "Player " + name + "\nAI: " + \
	str(personality) + "\nValue: " + str(hand_value) + "\nHand:\n"
	for cards in hand:
		assigned_gc_label.text += str(cards.rank) + " of " + str(cards.suit) + ",\n"

func update_action_label(action):
	action_label.text = str(action)

func go_to_table(chair_pos):
	#print(chair_pos)
	nav.set_target_position(chair_pos)

func _on_nav_navigation_finished() -> void:
	is_sat_down = true

func look_at_player():
	look_at($"../bj_player_test".position)
	rotation.x = 0
	rotation.z = 0
