extends Control

@onready var game: Control = $"../../.."
@onready var hand_labels : Array = [$BoxContainer/VBoxContainer/hand1/RichTextLabel, 
$BoxContainer/VBoxContainer/hand2/RichTextLabel,
$BoxContainer/VBoxContainer/hand3/RichTextLabel,
$BoxContainer/VBoxContainer/hand4/RichTextLabel]
@onready var value_labels : Array = [$BoxContainer/VBoxContainer/value1/Label,
$BoxContainer/VBoxContainer/value2/Label,
$BoxContainer/VBoxContainer/value3/Label,
$BoxContainer/VBoxContainer/value4/Label]

@onready var label_name: Label = $BoxContainer/VBoxContainer/name/Label
@onready var state: Label = $BoxContainer/VBoxContainer/state/Label

var hands : Array = [hand0, hand1, hand2, hand3]
var hand_values : Array = [hand0_value, hand1_value, hand2_value, hand3_value]
@export_enum("Playing", "Standed", "Surrendered", "Doubled", "Busted")
var hand0_state : String = "Playing"
var hand0 : Array = []
var hand0_value : int = 0
var hand1_state : String = "Playing"
var hand1 : Array = []
var hand1_value : int = 0
var hand2_state : String = "Playing"
var hand2 : Array = []
var hand2_value : int = 0
var hand3_state : String = "Playing"
var hand3 : Array = []
var hand3_value : int = 0
var playing = true
var standed = false
var busted = false
var doubled_down = false
var surrendered = false
var blackjack_in_hand = false

#personalities defining how the AI plays
var personality : String
#personality, weight of being chosen
var personality_list : Array = [["Strategic", 70], ["Coward", 90], ["Noob", 100]]

func _process(delta: float) -> void:
	#defining label text
	for labels in hand_labels.size():
		hand_labels[labels].text = str(hands[labels])
	
	for labels in value_labels.size():
		value_labels[labels].text = "Value: " + str(hand_values[labels])
	
	label_name.text = personality + " " + name
	
	#turn on hand labels if the hands are being used
	for num_of_hands in hands.size():
		if hands[num_of_hands].is_empty():
			hand_labels[num_of_hands].visible = true
			hand_values[num_of_hands].visible = true
	
	if standed != true and busted != true and blackjack_in_hand != true \
	and doubled_down != true and surrendered != true:
		playing = true
		state.text = "(Playing)"
	else:
		playing = false
		if standed == true:
			state.text = "(Standed)"
		if blackjack_in_hand == true:
			state.text = "(Blackjack)"
		if doubled_down == true:
			state.text = "(Doubled Down)"
		if surrendered == true:
			state.text = "(Surrendered)"
		if busted == true:
			state.text = "(Busted)"

func _hand_act():
	_act(hand, hand_value)

func _hand2_act():
	_act(hand2, hand2_value)

func _hand3_act():
	_act(hand3, hand3_value)

func _hand4_act():
	_act(hand4, hand4_value)

func _act(acting_hand, acting_hand_value):
	if standed != true and busted != true and blackjack_in_hand != true \
	and doubled_down != true and surrendered != true:
		if acting_hand_value >= 22:
			_bust()
		if acting_hand_value == 21 and acting_hand.size() == 2:
			var has_ace : bool
			var has_ten_value : bool
			for card in acting_hand.size():
				if acting_hand[card].has("Ace"):
					has_ace = true
				if acting_hand[card].has("10") or acting_hand[card].has("Jack") or \
				acting_hand[card].has("Queen") or acting_hand[card].has("King"):
					has_ten_value = true
			if has_ace and has_ten_value:
				_blackjack()
			elif acting_hand_value == 21 and acting_hand.size() > 2:
				_stand()
		elif acting_hand_value == 21 and acting_hand.size() > 2:
			_stand()
		if personality == "Strategic" and busted != true:
			var has_aces : bool = false
			for card in acting_hand.size():
				if has_aces == false:
					if acting_hand[card][1] == "Ace":
						has_aces = true
			if acting_hand[0][1] != acting_hand[1][1]:
				if has_aces == false:
					print("Has no aces or pairs")
					match game.dealer_hand[0][1]:
						"2":
							match acting_hand_value:
								5:
									_hit()
								6:
									_hit()
								7:
									_hit()
								8:
									_hit()
								9:
									_hit()
								10:
									_double_down()
								11:
									_double_down()
								12:
									_hit()
								13:
									_stand()
								14:
									_stand()
								15:
									_stand()
								16:
									_stand()
								17:
									_stand()
								18:
									_stand()
								19:
									_stand()
								20:
									_stand()
								21:
									_stand()
						"3":
							match acting_hand_value:
								5:
									_hit()
								6:
									_hit()
								7:
									_hit()
								8:
									_hit()
								9:
									_double_down()
								10:
									_double_down()
								11:
									_double_down()
								12:
									_hit()
								13:
									_stand()
								14:
									_stand()
								15:
									_stand()
								16:
									_stand()
								17:
									_stand()
								18:
									_stand()
								19:
									_stand()
								20:
									_stand()
								21:
									_stand()
						"4":
							match acting_hand_value:
								5:
									_hit()
								6:
									_hit()
								7:
									_hit()
								8:
									_hit()
								9:
									_double_down()
								10:
									_double_down()
								11:
									_double_down()
								12:
									_stand()
								13:
									_stand()
								14:
									_stand()
								15:
									_stand()
								16:
									_stand()
								17:
									_stand()
								18:
									_stand()
								19:
									_stand()
								20:
									_stand()
								21:
									_stand()
						"5":
							match acting_hand_value:
								5:
									_hit()
								6:
									_hit()
								7:
									_hit()
								8:
									_hit()
								9:
									_double_down()
								10:
									_double_down()
								11:
									_double_down()
								12:
									_stand()
								13:
									_stand()
								14:
									_stand()
								15:
									_stand()
								16:
									_stand()
								17:
									_stand()
								18:
									_stand()
								19:
									_stand()
								20:
									_stand()
								21:
									_stand()
						"6":
							match acting_hand_value:
								5:
									_hit()
								6:
									_hit()
								7:
									_hit()
								8:
									_hit()
								9:
									_double_down()
								10:
									_double_down()
								11:
									_double_down()
								12:
									_stand()
								13:
									_stand()
								14:
									_stand()
								15:
									_stand()
								16:
									_stand()
								17:
									_stand()
								18:
									_stand()
								19:
									_stand()
								20:
									_stand()
								21:
									_stand()
						"7":
							match acting_hand_value:
								5:
									_hit()
								6:
									_hit()
								7:
									_hit()
								8:
									_hit()
								9:
									_hit()
								10:
									_double_down()
								11:
									_double_down()
								12:
									_hit()
								13:
									_hit()
								14:
									_hit()
								15:
									_hit()
								16:
									_hit()
								17:
									_stand()
								18:
									_stand()
								19:
									_stand()
								20:
									_stand()
								21:
									_stand()
						"8":
							match acting_hand_value:
								5:
									_hit()
								6:
									_hit()
								7:
									_hit()
								8:
									_hit()
								9:
									_hit()
								10:
									_double_down()
								11:
									_double_down()
								12:
									_hit()
								13:
									_hit()
								14:
									_hit()
								15:
									_hit()
								16:
									_hit()
								17:
									_stand()
								18:
									_stand()
								19:
									_stand()
								20:
									_stand()
								21:
									_stand()
						"9":
							match acting_hand_value:
								5:
									_hit()
								6:
									_hit()
								7:
									_hit()
								8:
									_hit()
								9:
									_hit()
								10:
									_double_down()
								11:
									_double_down()
								12:
									_hit()
								13:
									_hit()
								14:
									_hit()
								15:
									_hit()
								16:
									#if not allowed, then hit
									_surrender()
								17:
									_stand()
								18:
									_stand()
								19:
									_stand()
								20:
									_stand()
								21:
									_stand()
						"10":
							match acting_hand_value:
								5:
									_hit()
								6:
									_hit()
								7:
									_hit()
								8:
									_hit()
								9:
									_hit()
								10:
									_hit()
								11:
									_double_down()
								12:
									_hit()
								13:
									_hit()
								14:
									_hit()
								15:
									#if not allowed, then hit
									_surrender()
								16:
									#if not allowed, then hit
									_surrender()
								17:
									_stand()
								18:
									_stand()
								19:
									_stand()
								20:
									_stand()
								21:
									_stand()
						"Jack":
							match acting_hand_value:
								5,6:
									_hit()
								
									_hit()
								7:
									_hit()
								8:
									_hit()
								9:
									_hit()
								10:
									_hit()
								11:
									_double_down()
								12:
									_hit()
								13:
									_hit()
								14:
									_hit()
								15:
									#if not allowed, then hit
									_surrender()
								16:
									#if not allowed, then hit
									_surrender()
								17:
									_stand()
								18:
									_stand()
								19:
									_stand()
								20:
									_stand()
								21:
									_stand()
						"Queen":
							match acting_hand_value:
								5:
									_hit()
								6:
									_hit()
								7:
									_hit()
								8:
									_hit()
								9:
									_hit()
								10:
									_hit()
								11:
									_double_down()
								12:
									_hit()
								13:
									_hit()
								14:
									_hit()
								15:
									#if not allowed, then hit
									_surrender()
								16:
									#if not allowed, then hit
									_surrender()
								17:
									_stand()
								18:
									_stand()
								19:
									_stand()
								20:
									_stand()
								21:
									_stand()
						"King":
							match acting_hand_value:
								5:
									_hit()
								6:
									_hit()
								7:
									_hit()
								8:
									_hit()
								9:
									_hit()
								10:
									_hit()
								11:
									_double_down()
								12:
									_hit()
								13:
									_hit()
								14:
									_hit()
								15:
									#if not allowed, then hit
									_surrender()
								16:
									#if not allowed, then hit
									_surrender()
								17:
									_stand()
								18:
									_stand()
								19:
									_stand()
								20:
									_stand()
								21:
									_stand()
						"Ace":
							match acting_hand_value:
								5:
									_hit()
								6:
									_hit()
								7:
									_hit()
								8:
									_hit()
								9:
									_hit()
								10:
									_hit()
								11:
									_double_down()
								12:
									_hit()
								13:
									_hit()
								14:
									_hit()
								15:
									#if not allowed, then hit
									_surrender()
								16:
									#if not allowed, then hit
									_surrender()
								17:
									#if not allowed, then stand
									_surrender()
								18:
									_stand()
								19:
									_stand()
								20:
									_stand()
								21:
									_stand()
				else:
					print("Has an Ace")
					match game.dealer_hand[0][1]:
						"2":
							match acting_hand_value:
								20:
									_stand()
								19:
									_stand()
								18:
									#if not allowed, then stand
									_double_down()
								17:
									_hit()
								16:
									_hit()
								15:
									_hit()
								14:
									_hit()
								13:
									_hit()
								12:
									_hit()
						"3":
							match acting_hand_value:
								20:
									_stand()
								19:
									_stand()
								18:
									#if not allowed, then stand
									_double_down()
								17:
									#if not allowed, then hit
									_double_down()
								16:
									_hit()
								15:
									_hit()
								14:
									_hit()
								13:
									_hit()
								12:
									_hit()
						"4":
							match acting_hand_value:
								20:
									_stand()
								19:
									_stand()
								18:
									#if not allowed, then stand
									_double_down()
								17:
									#if not allowed, then hit
									_double_down()
								16:
									#if not allowed, then hit
									_double_down()
								15:
									#if not allowed, then hit
									_double_down()
								14:
									_hit()
								13:
									_hit()
								12:
									_hit()
						"5":
							match acting_hand_value:
								20:
									_stand()
								19:
									_stand()
								18:
									#if not allowed, then stand
									_double_down()
								17:
									#if not allowed, then hit
									_double_down()
								16:
									#if not allowed, then hit
									_double_down()
								15:
									#if not allowed, then hit
									_double_down()
								14:
									#if not allowed, then hit
									_double_down()
								13:
									#if not allowed, then hit
									_double_down()
								12:
									_hit()
						"6":
							match acting_hand_value:
								20:
									_stand()
								19:
									#if not allowed, then stand
									_double_down()
								18:
									#if not allowed, then stand
									_double_down()
								17:
									#if not allowed, then hit
									_double_down()
								16:
									#if not allowed, then hit
									_double_down()
								15:
									#if not allowed, then hit
									_double_down()
								14:
									#if not allowed, then hit
									_double_down()
								13:
									#if not allowed, then hit
									_double_down()
								12:
									#if not allowed, then hit
									_double_down()
						"7":
							match acting_hand_value:
								20:
									_stand()
								19:
									_stand()
								18:
									_stand()
								17:
									_hit()
								16:
									_hit()
								15:
									_hit()
								14:
									_hit()
								13:
									_hit()
								12:
									_hit()
						"8":
							match acting_hand_value:
								20:
									_stand()
								19:
									_stand()
								18:
									_stand()
								17:
									_hit()
								16:
									_hit()
								15:
									_hit()
								14:
									_hit()
								13:
									_hit()
								12:
									_hit()
						"9":
							match acting_hand_value:
								20:
									_stand()
								19:
									_stand()
								18:
									_hit()
								17:
									_hit()
								16:
									_hit()
								15:
									_hit()
								14:
									_hit()
								13:
									_hit()
								12:
									_hit()
						"10":
							match acting_hand_value:
								20:
									_stand()
								19:
									_stand()
								18:
									_hit()
								17:
									_hit()
								16:
									_hit()
								15:
									_hit()
								14:
									_hit()
								13:
									_hit()
								12:
									_hit()
						"Jack":
							match acting_hand_value:
								20:
									_stand()
								19:
									_stand()
								18:
									_hit()
								17:
									_hit()
								16:
									_hit()
								15:
									_hit()
								14:
									_hit()
								13:
									_hit()
								12:
									_hit()
						"Queen":
							match acting_hand_value:
								20:
									_stand()
								19:
									_stand()
								18:
									_hit()
								17:
									_hit()
								16:
									_hit()
								15:
									_hit()
								14:
									_hit()
								13:
									_hit()
								12:
									_hit()
						"King":
							match acting_hand_value:
								20:
									_stand()
								19:
									_stand()
								18:
									_hit()
								17:
									_hit()
								16:
									_hit()
								15:
									_hit()
								14:
									_hit()
								13:
									_hit()
								12:
									_hit()
						"Ace":
							match acting_hand_value:
								20:
									_stand()
								19:
									_stand()
								18:
									_hit()
								17:
									_hit()
								16:
									_hit()
								15:
									_hit()
								14:
									_hit()
								13:
									_hit()
								12:
									_hit()
			else:
				print("Has a pair of " + acting_hand[0][1] + "s")
				match game.dealer_hand[0][1]:
					"2":
						match acting_hand[0][1]:
							"Ace":
								_split(1)
							"King":
								_stand()
							"Queen":
								_stand()
							"Jack":
								_stand()
							"10":
								_stand()
							"9":
								_split(1)
							"8":
								_split(1)
							"7":
								_split(1)
							"6":
								_split(1)
							"5":
								#if not allowed, then hit
								_double_down()
							"4":
								_hit()
							"3":
								_split(1)
							"2":
								_split(1)
					"3":
						match acting_hand[0][1]:
							"Ace":
								_split(1)
							"King":
								_stand()
							"Queen":
								_stand()
							"Jack":
								_stand()
							"10":
								_stand()
							"9":
								_split(1)
							"8":
								_split(1)
							"7":
								_split(1)
							"6":
								_split(1)
							"5":
								#if not allowed, then hit
								_double_down()
							"4":
								_hit()
							"3":
								_split(1)
							"2":
								_split(1)
					"4":
						match acting_hand[0][1]:
							"Ace":
								_split(1)
							"King":
								_stand()
							"Queen":
								_stand()
							"Jack":
								_stand()
							"10":
								_stand()
							"9":
								_split(1)
							"8":
								_split(1)
							"7":
								_split(1)
							"6":
								_split(1)
							"5":
								#if not allowed, then hit
								_double_down()
							"4":
								_hit()
							"3":
								_split(1)
							"2":
								_split(1)
					"5":
						match acting_hand[0][1]:
							"Ace":
								_split(1)
							"King":
								_stand()
							"Queen":
								_stand()
							"Jack":
								_stand()
							"10":
								_stand()
							"9":
								_split(1)
							"8":
								_split(1)
							"7":
								_split(1)
							"6":
								_split(1)
							"5":
								#if not allowed, then hit
								_double_down()
							"4":
								_split(1)
							"3":
								_split(1)
							"2":
								_split(1)
					"6":
						match acting_hand[0][1]:
							"Ace":
								_split(1)
							"King":
								_stand()
							"Queen":
								_stand()
							"Jack":
								_stand()
							"10":
								_stand()
							"9":
								_split(1)
							"8":
								_split(1)
							"7":
								_split(1)
							"6":
								_split(1)
							"5":
								#if not allowed, then hit
								_double_down()
							"4":
								_split(1)
							"3":
								_split(1)
							"2":
								_split(1)
					"7":
						match acting_hand[0][1]:
							"Ace":
								_split(1)
							"King":
								_stand()
							"Queen":
								_stand()
							"Jack":
								_stand()
							"10":
								_stand()
							"9":
								_stand()
							"8":
								_split(1)
							"7":
								_split(1)
							"6":
								_hit()
							"5":
								#if not allowed, then hit
								_double_down()
							"4":
								_hit()
							"3":
								_split(1)
							"2":
								_split(1)
					"8":
						match acting_hand[0][1]:
							"Ace":
								_split(1)
							"King":
								_stand()
							"Queen":
								_stand()
							"Jack":
								_stand()
							"10":
								_stand()
							"9":
								_split(1)
							"8":
								_split(1)
							"7":
								_hit()
							"6":
								_hit()
							"5":
								#if not allowed, then hit
								_double_down()
							"4":
								_hit()
							"3":
								_hit()
							"2":
								_hit()
					"9":
						match acting_hand[0][1]:
							"Ace":
								_split(1)
							"King":
								_stand()
							"Queen":
								_stand()
							"Jack":
								_stand()
							"10":
								_stand()
							"9":
								_split(1)
							"8":
								_split(1)
							"7":
								_hit()
							"6":
								_hit()
							"5":
								#if not allowed, then hit
								_double_down()
							"4":
								_hit()
							"3":
								_hit()
							"2":
								_hit()
					"10":
						match acting_hand[0][1]:
							"Ace":
								_split(1)
							"King":
								_stand()
							"Queen":
								_stand()
							"Jack":
								_stand()
							"10":
								_stand()
							"9":
								_stand()
							"8":
								_split(1)
							"7":
								_hit()
							"6":
								_hit()
							"5":
								_hit()
							"4":
								_hit()
							"3":
								_hit()
							"2":
								_hit()
					"Jack":
						match acting_hand[0][1]:
							"Ace":
								_split(1)
							"King":
								_stand()
							"Queen":
								_stand()
							"Jack":
								_stand()
							"10":
								_stand()
							"9":
								_stand()
							"8":
								_split(1)
							"7":
								_hit()
							"6":
								_hit()
							"5":
								_hit()
							"4":
								_hit()
							"3":
								_hit()
							"2":
								_hit()
					"Queen":
						match acting_hand[0][1]:
							"Ace":
								_split(1)
							"King":
								_stand()
							"Queen":
								_stand()
							"Jack":
								_stand()
							"10":
								_stand()
							"9":
								_stand()
							"8":
								_split(1)
							"7":
								_hit()
							"6":
								_hit()
							"5":
								_hit()
							"4":
								_hit()
							"3":
								_hit()
							"2":
								_hit()
					"King":
						match acting_hand[0][1]:
							"Ace":
								_split(1)
							"King":
								_stand()
							"Queen":
								_stand()
							"Jack":
								_stand()
							"10":
								_stand()
							"9":
								_stand()
							"8":
								_split(1)
							"7":
								_hit()
							"6":
								_hit()
							"5":
								_hit()
							"4":
								_hit()
							"3":
								_hit()
							"2":
								_hit()
					"Ace":
						match acting_hand[0][1]:
							"Ace":
								_split(1)
							"King":
								_stand()
							"Queen":
								_stand()
							"Jack":
								_stand()
							"10":
								_stand()
							"9":
								_stand()
							"8":
								#if not allowed, then split
								_surrender()
							"7":
								_hit()
							"6":
								_hit()
							"5":
								_hit()
							"4":
								_hit()
							"3":
								_hit()
							"2":
								_hit()
		elif personality == "Coward" and busted != true:
			if acting_hand_value + 10 >= 22:
				_stand()
			else:
				_hit()
		elif personality == "Noob" and busted != true:
			var actions = [_hit(), _stand()]
			actions.pick_random()
	else:
		if busted:
			print(self.name + " has busted! Skipping turn")
		elif standed:
			print(self.name + " has already standed. Skipping turn")
		elif doubled_down:
			print(self.name + " has already doubled down, and will not get cards. Skipping turn")
		elif surrendered:
			print(self.name + " has surrendered. Skipping turn")
		elif blackjack_in_hand:
			print(self.name + " has a blackjack in hand. Skipping turn")
	game.player_action.start()

func _hit():
	print(self.name + " hits.")
	game._player_add_card(self)

func _stand():
	print(self.name + " stands.")
	standed = true

func _double_down():
	print(self.name + " double downs!")
	doubled_down = true
	_hit()

func _split(action_number):
	print(self.name + " splits!")
	if action_number == 1:
		if hand2.is_empty() == true:
			hand2.push_front(hand.pop_front())
			game._player_add_card(self)
			game._player_add_card2(self)
		elif hand3.is_empty() == true:
			hand3.push_front(hand.pop_front())
			game._player_add_card(self)
			game._player_add_card3(self)
		elif hand4.is_empty() == true:
			hand4.push_front(hand.pop_front())
			game._player_add_card(self)
			game._player_add_card4(self)
	elif action_number == 2:
		if hand3.is_empty() == true:
			hand3.push_front(hand2.pop_front())
			game._player_add_card2(self)
			game._player_add_card3(self)
		elif hand4.is_empty() == true:
			hand4.push_front(hand2.pop_front())
			game._player_add_card2(self)
			game._player_add_card3(self)
	elif action_number == 3:
		if hand4.is_empty() == true:
			hand4.push_front(hand3.pop_front())
			game._player_add_card3(self)
			game._player_add_card4(self)
	elif action_number == 4:
		print("...and has reached max splits. Skipping turn")

func _surrender():
	print(self.name + " surrenders!")
	surrendered = true

func _blackjack():
	print(self.name + " has a blackjack!")
	blackjack_in_hand = true

func _bust():
	print(self.name + " busted!")
	busted = true

#chooses how the AI plays
func _decide_personality():
	#from a random number 0-100
	var chosen_personality = randi_range(0, 100)
	#for all the personalities
	for type in personality_list.size():
		#if there is no type with smaller weight (before type)
		if chosen_personality > personality_list[0][1]:
			#if the random number is bigger than the previous type's weight
			#and smaller than type's weight (in weight range)
			if personality_list[type][1] >= chosen_personality and \
			personality_list[type - 1][1] < chosen_personality:
				#choose type as personality
				personality = personality_list[type][0]
		else:
			personality = personality_list[0][0]
	print(name, personality, chosen_personality)
