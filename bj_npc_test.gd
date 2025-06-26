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
@onready var state_labels : Array = [$BoxContainer/VBoxContainer/value1/state,
$BoxContainer/VBoxContainer/value2/state,
$BoxContainer/VBoxContainer/value3/state,
$BoxContainer/VBoxContainer/value4/state,
]

@onready var label_name: Label = $BoxContainer/VBoxContainer/name/Label
@onready var state: Label = $BoxContainer/VBoxContainer/state/Label

var hands : Array = [hand0, hand1, hand2, hand3]
var hand_values : Array = [hand0_value, hand1_value, hand2_value, hand3_value]
@export_enum("Playing", "Standed", "Surrendered", "Doubled", "Busted", "Blackjack")
var hand0_state : String = "Playing"
var hand0 : Array
var hand0_value : int = 0
@export_enum("Playing", "Standed", "Surrendered", "Doubled", "Busted", "Blackjack")
var hand1_state : String = "Playing"
var hand1 : Array
var hand1_value : int = 0
@export_enum("Playing", "Standed", "Surrendered", "Doubled", "Busted", "Blackjack")
var hand2_state : String = "Playing"
var hand2 : Array
var hand2_value : int = 0
@export_enum("Playing", "Standed", "Surrendered", "Doubled", "Busted", "Blackjack")
var hand3_state : String = "Playing"
var hand3 : Array
var hand3_value : int = 0

var state_array : Array = [hand0_state, hand1_state, hand2_state, hand3_state]
var playing = true
#var standed = false
#var busted = false
#var doubled_down = false
#var surrendered = false
#var blackjack_in_hand = false

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
	
	for labels in state_labels.size():
		state_labels[labels].text = "(" + \
		state_array[labels].erase(2, state_array[labels].length() - 2) + ")"
	
	label_name.text = personality + " " + name
	
	#turn on hand labels if the hands are being used
	for num_of_hands in hands.size():
		if hands[num_of_hands].is_empty():
			hand_labels[num_of_hands].visible = true
			value_labels[num_of_hands].visible = true
	
	#if standed != true and busted != true and blackjack_in_hand != true \
	#and doubled_down != true and surrendered != true:
	if hand0_state == "Playing" and hand1_state == "Playing" and \
	hand2_state == "Playing" and hand3_state == "Playing":
		playing = true
		state.text = "(Playing)"
	else:
		playing = false
		state.text = "(Finished)"
		#if standed == true:
			#state.text = "(Standed)"
		#if blackjack_in_hand == true:
			#state.text = "(Blackjack)"
		#if doubled_down == true:
			#state.text = "(Doubled Down)"
		#if surrendered == true:
			#state.text = "(Surrendered)"
		#if busted == true:
			#state.text = "(Busted)"

func _act(acting_hand, acting_hand_value, acting_hand_state):
	if acting_hand_state == "Playing":
		if acting_hand_value >= 22:
			_bust(acting_hand)
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
				_blackjack(acting_hand)
			elif acting_hand_value == 21 and acting_hand.size() > 2:
				_stand(acting_hand)
		elif acting_hand_value == 21 and acting_hand.size() > 2:
			_stand(acting_hand)
		if personality == "Strategic" and acting_hand_state != "Busted":
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
									_hit(acting_hand)
								6:
									_hit(acting_hand)
								7:
									_hit(acting_hand)
								8:
									_hit(acting_hand)
								9:
									_hit(acting_hand)
								10:
									_double_down(acting_hand)
								11:
									_double_down(acting_hand)
								12:
									_hit(acting_hand)
								13:
									_stand(acting_hand)
								14:
									_stand(acting_hand)
								15:
									_stand(acting_hand)
								16:
									_stand(acting_hand)
								17:
									_stand(acting_hand)
								18:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								20:
									_stand(acting_hand)
								21:
									_stand(acting_hand)
						"3":
							match acting_hand_value:
								5:
									_hit(acting_hand)
								6:
									_hit(acting_hand)
								7:
									_hit(acting_hand)
								8:
									_hit(acting_hand)
								9:
									_double_down(acting_hand)
								10:
									_double_down(acting_hand)
								11:
									_double_down(acting_hand)
								12:
									_hit(acting_hand)
								13:
									_stand(acting_hand)
								14:
									_stand(acting_hand)
								15:
									_stand(acting_hand)
								16:
									_stand(acting_hand)
								17:
									_stand(acting_hand)
								18:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								20:
									_stand(acting_hand)
								21:
									_stand(acting_hand)
						"4":
							match acting_hand_value:
								5:
									_hit(acting_hand)
								6:
									_hit(acting_hand)
								7:
									_hit(acting_hand)
								8:
									_hit(acting_hand)
								9:
									_double_down(acting_hand)
								10:
									_double_down(acting_hand)
								11:
									_double_down(acting_hand)
								12:
									_stand(acting_hand)
								13:
									_stand(acting_hand)
								14:
									_stand(acting_hand)
								15:
									_stand(acting_hand)
								16:
									_stand(acting_hand)
								17:
									_stand(acting_hand)
								18:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								20:
									_stand(acting_hand)
								21:
									_stand(acting_hand)
						"5":
							match acting_hand_value:
								5:
									_hit(acting_hand)
								6:
									_hit(acting_hand)
								7:
									_hit(acting_hand)
								8:
									_hit(acting_hand)
								9:
									_double_down(acting_hand)
								10:
									_double_down(acting_hand)
								11:
									_double_down(acting_hand)
								12:
									_stand(acting_hand)
								13:
									_stand(acting_hand)
								14:
									_stand(acting_hand)
								15:
									_stand(acting_hand)
								16:
									_stand(acting_hand)
								17:
									_stand(acting_hand)
								18:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								20:
									_stand(acting_hand)
								21:
									_stand(acting_hand)
						"6":
							match acting_hand_value:
								5:
									_hit(acting_hand)
								6:
									_hit(acting_hand)
								7:
									_hit(acting_hand)
								8:
									_hit(acting_hand)
								9:
									_double_down(acting_hand)
								10:
									_double_down(acting_hand)
								11:
									_double_down(acting_hand)
								12:
									_stand(acting_hand)
								13:
									_stand(acting_hand)
								14:
									_stand(acting_hand)
								15:
									_stand(acting_hand)
								16:
									_stand(acting_hand)
								17:
									_stand(acting_hand)
								18:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								20:
									_stand(acting_hand)
								21:
									_stand(acting_hand)
						"7":
							match acting_hand_value:
								5:
									_hit(acting_hand)
								6:
									_hit(acting_hand)
								7:
									_hit(acting_hand)
								8:
									_hit(acting_hand)
								9:
									_hit(acting_hand)
								10:
									_double_down(acting_hand)
								11:
									_double_down(acting_hand)
								12:
									_hit(acting_hand)
								13:
									_hit(acting_hand)
								14:
									_hit(acting_hand)
								15:
									_hit(acting_hand)
								16:
									_hit(acting_hand)
								17:
									_stand(acting_hand)
								18:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								20:
									_stand(acting_hand)
								21:
									_stand(acting_hand)
						"8":
							match acting_hand_value:
								5:
									_hit(acting_hand)
								6:
									_hit(acting_hand)
								7:
									_hit(acting_hand)
								8:
									_hit(acting_hand)
								9:
									_hit(acting_hand)
								10:
									_double_down(acting_hand)
								11:
									_double_down(acting_hand)
								12:
									_hit(acting_hand)
								13:
									_hit(acting_hand)
								14:
									_hit(acting_hand)
								15:
									_hit(acting_hand)
								16:
									_hit(acting_hand)
								17:
									_stand(acting_hand)
								18:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								20:
									_stand(acting_hand)
								21:
									_stand(acting_hand)
						"9":
							match acting_hand_value:
								5:
									_hit(acting_hand)
								6:
									_hit(acting_hand)
								7:
									_hit(acting_hand)
								8:
									_hit(acting_hand)
								9:
									_hit(acting_hand)
								10:
									_double_down(acting_hand)
								11:
									_double_down(acting_hand)
								12:
									_hit(acting_hand)
								13:
									_hit(acting_hand)
								14:
									_hit(acting_hand)
								15:
									_hit(acting_hand)
								16:
									#if not allowed, then hit
									_surrender(acting_hand)
								17:
									_stand(acting_hand)
								18:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								20:
									_stand(acting_hand)
								21:
									_stand(acting_hand)
						"10":
							match acting_hand_value:
								5:
									_hit(acting_hand)
								6:
									_hit(acting_hand)
								7:
									_hit(acting_hand)
								8:
									_hit(acting_hand)
								9:
									_hit(acting_hand)
								10:
									_hit(acting_hand)
								11:
									_double_down(acting_hand)
								12:
									_hit(acting_hand)
								13:
									_hit(acting_hand)
								14:
									_hit(acting_hand)
								15:
									#if not allowed, then hit
									_surrender(acting_hand)
								16:
									#if not allowed, then hit
									_surrender(acting_hand)
								17:
									_stand(acting_hand)
								18:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								20:
									_stand(acting_hand)
								21:
									_stand(acting_hand)
						"Jack":
							match acting_hand_value:
								5,6:
									_hit(acting_hand)
								
									_hit(acting_hand)
								7:
									_hit(acting_hand)
								8:
									_hit(acting_hand)
								9:
									_hit(acting_hand)
								10:
									_hit(acting_hand)
								11:
									_double_down(acting_hand)
								12:
									_hit(acting_hand)
								13:
									_hit(acting_hand)
								14:
									_hit(acting_hand)
								15:
									#if not allowed, then hit
									_surrender(acting_hand)
								16:
									#if not allowed, then hit
									_surrender(acting_hand)
								17:
									_stand(acting_hand)
								18:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								20:
									_stand(acting_hand)
								21:
									_stand(acting_hand)
						"Queen":
							match acting_hand_value:
								5:
									_hit(acting_hand)
								6:
									_hit(acting_hand)
								7:
									_hit(acting_hand)
								8:
									_hit(acting_hand)
								9:
									_hit(acting_hand)
								10:
									_hit(acting_hand)
								11:
									_double_down(acting_hand)
								12:
									_hit(acting_hand)
								13:
									_hit(acting_hand)
								14:
									_hit(acting_hand)
								15:
									#if not allowed, then hit
									_surrender(acting_hand)
								16:
									#if not allowed, then hit
									_surrender(acting_hand)
								17:
									_stand(acting_hand)
								18:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								20:
									_stand(acting_hand)
								21:
									_stand(acting_hand)
						"King":
							match acting_hand_value:
								5:
									_hit(acting_hand)
								6:
									_hit(acting_hand)
								7:
									_hit(acting_hand)
								8:
									_hit(acting_hand)
								9:
									_hit(acting_hand)
								10:
									_hit(acting_hand)
								11:
									_double_down(acting_hand)
								12:
									_hit(acting_hand)
								13:
									_hit(acting_hand)
								14:
									_hit(acting_hand)
								15:
									#if not allowed, then hit
									_surrender(acting_hand)
								16:
									#if not allowed, then hit
									_surrender(acting_hand)
								17:
									_stand(acting_hand)
								18:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								20:
									_stand(acting_hand)
								21:
									_stand(acting_hand)
						"Ace":
							match acting_hand_value:
								5:
									_hit(acting_hand)
								6:
									_hit(acting_hand)
								7:
									_hit(acting_hand)
								8:
									_hit(acting_hand)
								9:
									_hit(acting_hand)
								10:
									_hit(acting_hand)
								11:
									_double_down(acting_hand)
								12:
									_hit(acting_hand)
								13:
									_hit(acting_hand)
								14:
									_hit(acting_hand)
								15:
									#if not allowed, then hit
									_surrender(acting_hand)
								16:
									#if not allowed, then hit
									_surrender(acting_hand)
								17:
									#if not allowed, then stand
									_surrender(acting_hand)
								18:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								20:
									_stand(acting_hand)
								21:
									_stand(acting_hand)
				else:
					print("Has an Ace")
					match game.dealer_hand[0][1]:
						"2":
							match acting_hand_value:
								20:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								18:
									#if not allowed, then stand
									_double_down(acting_hand)
								17:
									_hit(acting_hand)
								16:
									_hit(acting_hand)
								15:
									_hit(acting_hand)
								14:
									_hit(acting_hand)
								13:
									_hit(acting_hand)
								12:
									_hit(acting_hand)
						"3":
							match acting_hand_value:
								20:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								18:
									#if not allowed, then stand
									_double_down(acting_hand)
								17:
									#if not allowed, then hit
									_double_down(acting_hand)
								16:
									_hit(acting_hand)
								15:
									_hit(acting_hand)
								14:
									_hit(acting_hand)
								13:
									_hit(acting_hand)
								12:
									_hit(acting_hand)
						"4":
							match acting_hand_value:
								20:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								18:
									#if not allowed, then stand
									_double_down(acting_hand)
								17:
									#if not allowed, then hit
									_double_down(acting_hand)
								16:
									#if not allowed, then hit
									_double_down(acting_hand)
								15:
									#if not allowed, then hit
									_double_down(acting_hand)
								14:
									_hit(acting_hand)
								13:
									_hit(acting_hand)
								12:
									_hit(acting_hand)
						"5":
							match acting_hand_value:
								20:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								18:
									#if not allowed, then stand
									_double_down(acting_hand)
								17:
									#if not allowed, then hit
									_double_down(acting_hand)
								16:
									#if not allowed, then hit
									_double_down(acting_hand)
								15:
									#if not allowed, then hit
									_double_down(acting_hand)
								14:
									#if not allowed, then hit
									_double_down(acting_hand)
								13:
									#if not allowed, then hit
									_double_down(acting_hand)
								12:
									_hit(acting_hand)
						"6":
							match acting_hand_value:
								20:
									_stand(acting_hand)
								19:
									#if not allowed, then stand
									_double_down(acting_hand)
								18:
									#if not allowed, then stand
									_double_down(acting_hand)
								17:
									#if not allowed, then hit
									_double_down(acting_hand)
								16:
									#if not allowed, then hit
									_double_down(acting_hand)
								15:
									#if not allowed, then hit
									_double_down(acting_hand)
								14:
									#if not allowed, then hit
									_double_down(acting_hand)
								13:
									#if not allowed, then hit
									_double_down(acting_hand)
								12:
									#if not allowed, then hit
									_double_down(acting_hand)
						"7":
							match acting_hand_value:
								20:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								18:
									_stand(acting_hand)
								17:
									_hit(acting_hand)
								16:
									_hit(acting_hand)
								15:
									_hit(acting_hand)
								14:
									_hit(acting_hand)
								13:
									_hit(acting_hand)
								12:
									_hit(acting_hand)
						"8":
							match acting_hand_value:
								20:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								18:
									_stand(acting_hand)
								17:
									_hit(acting_hand)
								16:
									_hit(acting_hand)
								15:
									_hit(acting_hand)
								14:
									_hit(acting_hand)
								13:
									_hit(acting_hand)
								12:
									_hit(acting_hand)
						"9":
							match acting_hand_value:
								20:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								18:
									_hit(acting_hand)
								17:
									_hit(acting_hand)
								16:
									_hit(acting_hand)
								15:
									_hit(acting_hand)
								14:
									_hit(acting_hand)
								13:
									_hit(acting_hand)
								12:
									_hit(acting_hand)
						"10":
							match acting_hand_value:
								20:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								18:
									_hit(acting_hand)
								17:
									_hit(acting_hand)
								16:
									_hit(acting_hand)
								15:
									_hit(acting_hand)
								14:
									_hit(acting_hand)
								13:
									_hit(acting_hand)
								12:
									_hit(acting_hand)
						"Jack":
							match acting_hand_value:
								20:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								18:
									_hit(acting_hand)
								17:
									_hit(acting_hand)
								16:
									_hit(acting_hand)
								15:
									_hit(acting_hand)
								14:
									_hit(acting_hand)
								13:
									_hit(acting_hand)
								12:
									_hit(acting_hand)
						"Queen":
							match acting_hand_value:
								20:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								18:
									_hit(acting_hand)
								17:
									_hit(acting_hand)
								16:
									_hit(acting_hand)
								15:
									_hit(acting_hand)
								14:
									_hit(acting_hand)
								13:
									_hit(acting_hand)
								12:
									_hit(acting_hand)
						"King":
							match acting_hand_value:
								20:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								18:
									_hit(acting_hand)
								17:
									_hit(acting_hand)
								16:
									_hit(acting_hand)
								15:
									_hit(acting_hand)
								14:
									_hit(acting_hand)
								13:
									_hit(acting_hand)
								12:
									_hit(acting_hand)
						"Ace":
							match acting_hand_value:
								20:
									_stand(acting_hand)
								19:
									_stand(acting_hand)
								18:
									_hit(acting_hand)
								17:
									_hit(acting_hand)
								16:
									_hit(acting_hand)
								15:
									_hit(acting_hand)
								14:
									_hit(acting_hand)
								13:
									_hit(acting_hand)
								12:
									_hit(acting_hand)
			else:
				print("Has a pair of " + acting_hand[0][1] + "s")
				match game.dealer_hand[0][1]:
					"2":
						match acting_hand[0][1]:
							"Ace":
								_split(1)
							"King":
								_stand(acting_hand)
							"Queen":
								_stand(acting_hand)
							"Jack":
								_stand(acting_hand)
							"10":
								_stand(acting_hand)
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
								_double_down(acting_hand)
							"4":
								_hit(acting_hand)
							"3":
								_split(1)
							"2":
								_split(1)
					"3":
						match acting_hand[0][1]:
							"Ace":
								_split(1)
							"King":
								_stand(acting_hand)
							"Queen":
								_stand(acting_hand)
							"Jack":
								_stand(acting_hand)
							"10":
								_stand(acting_hand)
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
								_double_down(acting_hand)
							"4":
								_hit(acting_hand)
							"3":
								_split(1)
							"2":
								_split(1)
					"4":
						match acting_hand[0][1]:
							"Ace":
								_split(1)
							"King":
								_stand(acting_hand)
							"Queen":
								_stand(acting_hand)
							"Jack":
								_stand(acting_hand)
							"10":
								_stand(acting_hand)
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
								_double_down(acting_hand)
							"4":
								_hit(acting_hand)
							"3":
								_split(1)
							"2":
								_split(1)
					"5":
						match acting_hand[0][1]:
							"Ace":
								_split(1)
							"King":
								_stand(acting_hand)
							"Queen":
								_stand(acting_hand)
							"Jack":
								_stand(acting_hand)
							"10":
								_stand(acting_hand)
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
								_double_down(acting_hand)
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
								_stand(acting_hand)
							"Queen":
								_stand(acting_hand)
							"Jack":
								_stand(acting_hand)
							"10":
								_stand(acting_hand)
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
								_double_down(acting_hand)
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
								_stand(acting_hand)
							"Queen":
								_stand(acting_hand)
							"Jack":
								_stand(acting_hand)
							"10":
								_stand(acting_hand)
							"9":
								_stand(acting_hand)
							"8":
								_split(1)
							"7":
								_split(1)
							"6":
								_hit(acting_hand)
							"5":
								#if not allowed, then hit
								_double_down(acting_hand)
							"4":
								_hit(acting_hand)
							"3":
								_split(1)
							"2":
								_split(1)
					"8":
						match acting_hand[0][1]:
							"Ace":
								_split(1)
							"King":
								_stand(acting_hand)
							"Queen":
								_stand(acting_hand)
							"Jack":
								_stand(acting_hand)
							"10":
								_stand(acting_hand)
							"9":
								_split(1)
							"8":
								_split(1)
							"7":
								_hit(acting_hand)
							"6":
								_hit(acting_hand)
							"5":
								#if not allowed, then hit
								_double_down(acting_hand)
							"4":
								_hit(acting_hand)
							"3":
								_hit(acting_hand)
							"2":
								_hit(acting_hand)
					"9":
						match acting_hand[0][1]:
							"Ace":
								_split(1)
							"King":
								_stand(acting_hand)
							"Queen":
								_stand(acting_hand)
							"Jack":
								_stand(acting_hand)
							"10":
								_stand(acting_hand)
							"9":
								_split(1)
							"8":
								_split(1)
							"7":
								_hit(acting_hand)
							"6":
								_hit(acting_hand)
							"5":
								#if not allowed, then hit
								_double_down(acting_hand)
							"4":
								_hit(acting_hand)
							"3":
								_hit(acting_hand)
							"2":
								_hit(acting_hand)
					"10":
						match acting_hand[0][1]:
							"Ace":
								_split(1)
							"King":
								_stand(acting_hand)
							"Queen":
								_stand(acting_hand)
							"Jack":
								_stand(acting_hand)
							"10":
								_stand(acting_hand)
							"9":
								_stand(acting_hand)
							"8":
								_split(1)
							"7":
								_hit(acting_hand)
							"6":
								_hit(acting_hand)
							"5":
								_hit(acting_hand)
							"4":
								_hit(acting_hand)
							"3":
								_hit(acting_hand)
							"2":
								_hit(acting_hand)
					"Jack":
						match acting_hand[0][1]:
							"Ace":
								_split(1)
							"King":
								_stand(acting_hand)
							"Queen":
								_stand(acting_hand)
							"Jack":
								_stand(acting_hand)
							"10":
								_stand(acting_hand)
							"9":
								_stand(acting_hand)
							"8":
								_split(1)
							"7":
								_hit(acting_hand)
							"6":
								_hit(acting_hand)
							"5":
								_hit(acting_hand)
							"4":
								_hit(acting_hand)
							"3":
								_hit(acting_hand)
							"2":
								_hit(acting_hand)
					"Queen":
						match acting_hand[0][1]:
							"Ace":
								_split(1)
							"King":
								_stand(acting_hand)
							"Queen":
								_stand(acting_hand)
							"Jack":
								_stand(acting_hand)
							"10":
								_stand(acting_hand)
							"9":
								_stand(acting_hand)
							"8":
								_split(1)
							"7":
								_hit(acting_hand)
							"6":
								_hit(acting_hand)
							"5":
								_hit(acting_hand)
							"4":
								_hit(acting_hand)
							"3":
								_hit(acting_hand)
							"2":
								_hit(acting_hand)
					"King":
						match acting_hand[0][1]:
							"Ace":
								_split(1)
							"King":
								_stand(acting_hand)
							"Queen":
								_stand(acting_hand)
							"Jack":
								_stand(acting_hand)
							"10":
								_stand(acting_hand)
							"9":
								_stand(acting_hand)
							"8":
								_split(1)
							"7":
								_hit(acting_hand)
							"6":
								_hit(acting_hand)
							"5":
								_hit(acting_hand)
							"4":
								_hit(acting_hand)
							"3":
								_hit(acting_hand)
							"2":
								_hit(acting_hand)
					"Ace":
						match acting_hand[0][1]:
							"Ace":
								_split(1)
							"King":
								_stand(acting_hand)
							"Queen":
								_stand(acting_hand)
							"Jack":
								_stand(acting_hand)
							"10":
								_stand(acting_hand)
							"9":
								_stand(acting_hand)
							"8":
								#if not allowed, then split
								_surrender(acting_hand)
							"7":
								_hit(acting_hand)
							"6":
								_hit(acting_hand)
							"5":
								_hit(acting_hand)
							"4":
								_hit(acting_hand)
							"3":
								_hit(acting_hand)
							"2":
								_hit(acting_hand)
		elif personality == "Coward" and acting_hand_state != "Busted":
			if acting_hand_value + 10 >= 22:
				_stand(acting_hand)
			else:
				_hit(acting_hand)
		elif personality == "Noob" and acting_hand_state != "Busted":
			var actions = [_hit(acting_hand), _stand(acting_hand)]
			actions.pick_random()
	else:
		if acting_hand_state == "Busted":
			print(self.name + " has busted! Skipping turn")
		elif acting_hand_state == "Standed":
			print(self.name + " has already standed. Skipping turn")
		elif acting_hand_state == "Doubled":
			print(self.name + " has already doubled down, and will not get cards. Skipping turn")
		elif acting_hand_state == "Surrendered":
			print(self.name + " has surrendered. Skipping turn")
		elif acting_hand_state == "Blackjack":
			print(self.name + " has a blackjack in hand. Skipping turn")
	game.player_action.start()

func _hit(acting_hand):
	print(self.name + " hits.")
	game._player_add_card(self, hands.find(acting_hand))

func _stand(acting_hand):
	print(self.name + " stands.")
	state_array[hands.find(acting_hand)] = "Standed"

func _double_down(acting_hand):
	print(self.name + " double downs!")
	state_array[hands.find(acting_hand)] = "Doubled"
	_hit(acting_hand)

func _split(action_number):
	print(self.name + " splits!")
	if action_number == 1:
		if hand1.is_empty() == true:
			hand1.push_front(hand0.pop_front())
			game._player_add_card(self)
			game._player_add_card2(self)
		elif hand2.is_empty() == true:
			hand2.push_front(hand0.pop_front())
			game._player_add_card(self)
			game._player_add_card3(self)
		elif hand3.is_empty() == true:
			hand3.push_front(hand0.pop_front())
			game._player_add_card(self)
			game._player_add_card4(self)
	elif action_number == 2:
		if hand2.is_empty() == true:
			hand2.push_front(hand1.pop_front())
			game._player_add_card2(self)
			game._player_add_card3(self)
		elif hand3.is_empty() == true:
			hand3.push_front(hand1.pop_front())
			game._player_add_card2(self)
			game._player_add_card3(self)
	elif action_number == 3:
		if hand3.is_empty() == true:
			hand3.push_front(hand2.pop_front())
			game._player_add_card3(self)
			game._player_add_card4(self)
	elif action_number == 4:
		print("...and has reached max splits. Skipping turn")

func _surrender(acting_hand):
	print(self.name + " surrenders!")
	state_array[hands.find(acting_hand)] = "Surrendered"

func _blackjack(acting_hand):
	print(self.name + " has a blackjack!")
	state_array[hands.find(acting_hand)] = "Blackjack"

func _bust(acting_hand):
	print(self.name + " busted!")
	state_array[hands.find(acting_hand)] = "Busted"

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
