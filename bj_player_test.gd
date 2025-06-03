extends Control

@onready var game: Control = $"../../.."
@onready var label_hand: RichTextLabel = $BoxContainer/VBoxContainer/hand1/RichTextLabel
@onready var label_hand2: RichTextLabel = $BoxContainer/VBoxContainer/hand2/RichTextLabel
@onready var label_hand3: RichTextLabel = $BoxContainer/VBoxContainer/hand3/RichTextLabel
@onready var label_hand4: RichTextLabel = $BoxContainer/VBoxContainer/hand4/RichTextLabel
@onready var value: Label = $BoxContainer/VBoxContainer/value1/Label
@onready var value2: Label = $BoxContainer/VBoxContainer/value2/Label
@onready var value3: Label = $BoxContainer/VBoxContainer/value3/Label
@onready var value4: Label = $BoxContainer/VBoxContainer/value4/Label

@onready var label_name: Label = $BoxContainer/VBoxContainer/name/Label
@onready var state: Label = $BoxContainer/VBoxContainer/state/Label

var hand : Array = []
var hand_value : int = 0
var hand2 : Array = []
var hand2_value : int = 0
var hand3 : Array = []
var hand3_value : int = 0
var hand4 : Array = []
var hand4_value : int = 0
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
	label_hand.text = str(hand)
	label_hand2.text = str(hand2)
	label_hand3.text = str(hand3)
	label_hand4.text = str(hand4)
	value.text = "Value: " + str(hand_value)
	value2.text = "Value: " + str(hand2_value)
	value3.text = "Value: " + str(hand3_value)
	value4.text = "Value: " + str(hand4_value)
	label_name.text = personality + " " + name
	
	if hand2.is_empty() == false:
		label_hand2.visible = true
		value2.visible = true
	else:
		label_hand2.visible = false
		value2.visible = false
	
	if hand3.is_empty() == false:
		label_hand3.visible = true
		value3.visible = true
	else:
		label_hand3.visible = false
		value3.visible = false
	
	if hand4.is_empty() == false:
		label_hand4.visible = true
		value4.visible = true
	else:
		label_hand4.visible = false
		value4.visible = false
	
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

func _act():
	if standed != true and busted != true and blackjack_in_hand != true \
	and doubled_down != true and surrendered != true:
		if hand_value >= 22:
			_bust()
		if hand_value == 21 and hand.size() == 2:
			var has_ace : bool
			var has_ten_value : bool
			for card in hand.size():
				if hand[card].has("Ace"):
					has_ace = true
				if hand[card].has("10") or hand[card].has("Jack") or \
				hand[card].has("Queen") or hand[card].has("King"):
					has_ten_value = true
			if has_ace and has_ten_value:
				_blackjack()
			elif hand_value == 21 and hand.size() > 2:
				_stand()
		elif hand_value == 21 and hand.size() > 2:
			_stand()
		if personality == "Strategic" and busted != true:
			var has_aces : bool = false
			for card in hand.size():
				if has_aces == false:
					if hand[card][1] == "Ace":
						has_aces = true
			if hand[0][1] != hand[1][1]:
				if has_aces == false:
					print("Has no aces or pairs")
					match game.dealer_hand[0][1]:
						"2":
							match hand_value:
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
							match hand_value:
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
							match hand_value:
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
							match hand_value:
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
							match hand_value:
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
							match hand_value:
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
							match hand_value:
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
							match hand_value:
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
							match hand_value:
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
							match hand_value:
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
						"Queen":
							match hand_value:
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
							match hand_value:
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
							match hand_value:
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
							match hand_value:
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
							match hand_value:
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
							match hand_value:
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
							match hand_value:
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
							match hand_value:
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
							match hand_value:
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
							match hand_value:
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
							match hand_value:
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
							match hand_value:
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
							match hand_value:
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
							match hand_value:
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
							match hand_value:
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
							match hand_value:
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
				print("Has a pair of " + hand[0][1] + "s")
				match game.dealer_hand[0][1]:
					"2":
						match hand[0][1]:
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
						match hand[0][1]:
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
						match hand[0][1]:
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
						match hand[0][1]:
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
						match hand[0][1]:
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
						match hand[0][1]:
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
						match hand[0][1]:
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
						match hand[0][1]:
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
						match hand[0][1]:
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
						match hand[0][1]:
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
						match hand[0][1]:
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
						match hand[0][1]:
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
						match hand[0][1]:
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
			_stand()
		elif personality == "Noob" and busted != true:
			var actions = [_hit(), _stand(), _surrender()]
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

func _act2():
	if standed != true and busted != true and blackjack_in_hand != true \
	and doubled_down != true and surrendered != true:
		if hand2_value >= 22:
			_bust()
		if hand2_value == 21 and hand2.size() == 2:
			var has_ace : bool
			var has_ten_value : bool
			for card in hand2.size():
				if hand2[card].has("Ace"):
					has_ace = true
				if hand2[card].has("10") or hand2[card].has("Jack") or \
				hand2[card].has("Queen") or hand2[card].has("King"):
					has_ten_value = true
			if has_ace and has_ten_value:
				_blackjack()
			elif hand2_value == 21 and hand2.size() > 2:
				_stand()
		elif hand2_value == 21 and hand2.size() > 2:
			_stand()
		if personality == "Strategic" and busted != true:
			var has_aces : bool = false
			for card in hand2.size():
				if has_aces == false:
					if hand2[card][1] == "Ace":
						has_aces = true
			if hand2[0][1] != hand2[1][1]:
				if has_aces == false:
					print("Has no aces or pairs")
					match game.dealer_hand[0][1]:
						"2":
							match hand2_value:
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
							match hand2_value:
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
							match hand2_value:
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
							match hand2_value:
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
							match hand2_value:
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
							match hand2_value:
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
							match hand2_value:
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
							match hand2_value:
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
							match hand2_value:
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
							match hand2_value:
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
						"Queen":
							match hand2_value:
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
							match hand2_value:
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
							match hand2_value:
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
							match hand2_value:
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
							match hand2_value:
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
							match hand2_value:
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
							match hand2_value:
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
							match hand2_value:
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
							match hand2_value:
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
							match hand2_value:
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
							match hand2_value:
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
							match hand2_value:
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
							match hand2_value:
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
							match hand2_value:
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
							match hand2_value:
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
							match hand2_value:
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
				print("Has a pair of " + hand2[0][1] + "s")
				match game.dealer_hand[0][1]:
					"2":
						match hand2[0][1]:
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
						match hand2[0][1]:
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
						match hand2[0][1]:
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
						match hand2[0][1]:
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
						match hand2[0][1]:
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
						match hand2[0][1]:
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
						match hand2[0][1]:
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
						match hand2[0][1]:
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
						match hand2[0][1]:
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
						match hand2[0][1]:
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
						match hand2[0][1]:
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
						match hand2[0][1]:
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
						match hand2[0][1]:
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
			_stand()
		elif personality == "Noob" and busted != true:
			var actions = [_hit(), _stand(), _surrender()]
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

func _act3():
	if standed != true and busted != true and blackjack_in_hand != true \
	and doubled_down != true and surrendered != true:
		if hand3_value >= 22:
			_bust()
		if hand3_value == 21 and hand3.size() == 2:
			var has_ace : bool
			var has_ten_value : bool
			for card in hand3.size():
				if hand3[card].has("Ace"):
					has_ace = true
				if hand3[card].has("10") or hand3[card].has("Jack") or \
				hand3[card].has("Queen") or hand3[card].has("King"):
					has_ten_value = true
			if has_ace and has_ten_value:
				_blackjack()
			elif hand3_value == 21 and hand3.size() > 2:
				_stand()
		elif hand3_value == 21 and hand3.size() > 2:
			_stand()
		if personality == "Strategic" and busted != true:
			var has_aces : bool = false
			for card in hand3.size():
				if has_aces == false:
					if hand3[card][1] == "Ace":
						has_aces = true
			if hand3[0][1] != hand3[1][1]:
				if has_aces == false:
					print("Has no aces or pairs")
					match game.dealer_hand[0][1]:
						"2":
							match hand3_value:
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
							match hand3_value:
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
							match hand3_value:
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
							match hand3_value:
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
							match hand3_value:
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
							match hand3_value:
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
							match hand3_value:
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
							match hand3_value:
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
							match hand3_value:
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
							match hand3_value:
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
						"Queen":
							match hand3_value:
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
							match hand3_value:
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
							match hand3_value:
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
							match hand3_value:
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
							match hand3_value:
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
							match hand3_value:
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
							match hand3_value:
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
							match hand3_value:
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
							match hand3_value:
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
							match hand3_value:
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
							match hand3_value:
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
							match hand3_value:
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
							match hand3_value:
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
							match hand3_value:
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
							match hand3_value:
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
							match hand3_value:
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
				print("Has a pair of " + hand3[0][1] + "s")
				match game.dealer_hand[0][1]:
					"2":
						match hand3[0][1]:
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
						match hand3[0][1]:
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
						match hand3[0][1]:
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
						match hand3[0][1]:
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
						match hand3[0][1]:
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
						match hand3[0][1]:
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
						match hand3[0][1]:
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
						match hand3[0][1]:
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
						match hand3[0][1]:
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
						match hand3[0][1]:
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
						match hand3[0][1]:
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
						match hand3[0][1]:
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
						match hand3[0][1]:
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
			_stand()
		elif personality == "Noob" and busted != true:
			var actions = [_hit(), _stand(), _surrender()]
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

func _act4():
	if standed != true and busted != true and blackjack_in_hand != true \
	and doubled_down != true and surrendered != true:
		if hand4_value >= 22:
			_bust()
		if hand4_value == 21 and hand4.size() == 2:
			var has_ace : bool
			var has_ten_value : bool
			for card in hand4.size():
				if hand4[card].has("Ace"):
					has_ace = true
				if hand4[card].has("10") or hand4[card].has("Jack") or \
				hand4[card].has("Queen") or hand4[card].has("King"):
					has_ten_value = true
			if has_ace and has_ten_value:
				_blackjack()
			elif hand4_value == 21 and hand4.size() > 2:
				_stand()
		elif hand4_value == 21 and hand4.size() > 2:
			_stand()
		if personality == "Strategic" and busted != true:
			var has_aces : bool = false
			for card in hand4.size():
				if has_aces == false:
					if hand4[card][1] == "Ace":
						has_aces = true
			if hand4[0][1] != hand4[1][1]:
				if has_aces == false:
					print("Has no aces or pairs")
					match game.dealer_hand[0][1]:
						"2":
							match hand4_value:
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
							match hand4_value:
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
							match hand4_value:
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
							match hand4_value:
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
							match hand4_value:
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
							match hand4_value:
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
							match hand4_value:
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
							match hand4_value:
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
							match hand4_value:
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
							match hand4_value:
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
						"Queen":
							match hand4_value:
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
							match hand4_value:
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
							match hand4_value:
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
							match hand4_value:
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
							match hand4_value:
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
							match hand4_value:
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
							match hand4_value:
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
							match hand4_value:
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
							match hand4_value:
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
							match hand4_value:
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
							match hand4_value:
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
							match hand4_value:
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
							match hand4_value:
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
							match hand4_value:
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
							match hand4_value:
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
							match hand4_value:
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
				print("Has a pair of " + hand4[0][1] + "s")
				match game.dealer_hand[0][1]:
					"2":
						match hand4[0][1]:
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
						match hand4[0][1]:
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
						match hand4[0][1]:
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
						match hand4[0][1]:
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
						match hand4[0][1]:
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
						match hand4[0][1]:
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
						match hand4[0][1]:
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
						match hand4[0][1]:
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
						match hand4[0][1]:
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
						match hand4[0][1]:
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
						match hand4[0][1]:
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
						match hand4[0][1]:
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
						match hand4[0][1]:
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
			_stand()
		elif personality == "Noob" and busted != true:
			var actions = [_hit(), _stand(), _surrender()]
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
