extends Control

@onready var label_hand: RichTextLabel = $BoxContainer/VBoxContainer/hand/RichTextLabel
@onready var game: Control = $"../../.."
@onready var value: Label = $BoxContainer/VBoxContainer/value/Label
@onready var label_name: Label = $BoxContainer/VBoxContainer/name/Label
@onready var state: Label = $BoxContainer/VBoxContainer/state/Label

var hand : Array = []
var hand_value : int = 0
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
	value.text = "Value: " + str(hand_value)
	label_name.text = name
	if standed != true and busted != true and blackjack_in_hand != true \
	and doubled_down != true and surrendered != true:
		state.text = "(Playing)"
	elif standed == true:
		state.text = "(Standed)"
	elif busted == true:
		state.text = "(Busted)"
	elif blackjack_in_hand == true:
		state.text = "(Blackjack)"
	elif doubled_down == true:
		state.text = "(Doubled Down)"
	elif surrendered == true:
		state.text = "(Surrendered)"

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
					print("Has a " + hand[0][1] + " and a " + hand[1][1])
					match game.dealer_hand[0][1]:
						"2":
							if hand[0][1] == "Ace" and \
							hand[1][1] == "9" or \
							hand[0][1] == "9" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "8" or \
							hand[0][1] == "8" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "7" or \
							hand[0][1] == "7" and \
							hand[1][1] == "Ace":
								#if not allowed, then stand
								_double_down()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "6" or \
							hand[0][1] == "6" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "5" or \
							hand[0][1] == "5" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "4" or \
							hand[0][1] == "4" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "3" or \
							hand[0][1] == "3" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "2" or \
							hand[0][1] == "2" and \
							hand[1][1] == "Ace":
								_hit()
						"3":
							if hand[0][1] == "Ace" and \
							hand[1][1] == "9" or \
							hand[0][1] == "9" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "8" or \
							hand[0][1] == "8" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "7" or \
							hand[0][1] == "7" and \
							hand[1][1] == "Ace":
								#if not allowed, then stand
								_double_down()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "6" or \
							hand[0][1] == "6" and \
							hand[1][1] == "Ace":
								#if not allowed, then hit
								_double_down()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "5" or \
							hand[0][1] == "5" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "4" or \
							hand[0][1] == "4" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "3" or \
							hand[0][1] == "3" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "2" or \
							hand[0][1] == "2" and \
							hand[1][1] == "Ace":
								_hit()
						"4":
							if hand[0][1] == "Ace" and \
							hand[1][1] == "9" or \
							hand[0][1] == "9" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "8" or \
							hand[0][1] == "8" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "7" or \
							hand[0][1] == "7" and \
							hand[1][1] == "Ace":
								#if not allowed, then stand
								_double_down()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "6" or \
							hand[0][1] == "6" and \
							hand[1][1] == "Ace":
								#if not allowed, then hit
								_double_down()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "5" or \
							hand[0][1] == "5" and \
							hand[1][1] == "Ace":
								#if not allowed, then hit
								_double_down()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "4" or \
							hand[0][1] == "4" and \
							hand[1][1] == "Ace":
								#if not allowed, then hit
								_double_down()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "3" or \
							hand[0][1] == "3" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "2" or \
							hand[0][1] == "2" and \
							hand[1][1] == "Ace":
								_hit()
						"5":
							if hand[0][1] == "Ace" and \
							hand[1][1] == "9" or \
							hand[0][1] == "9" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "8" or \
							hand[0][1] == "8" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "7" or \
							hand[0][1] == "7" and \
							hand[1][1] == "Ace":
								#if not allowed, then stand
								_double_down()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "6" or \
							hand[0][1] == "6" and \
							hand[1][1] == "Ace":
								#if not allowed, then hit
								_double_down()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "5" or \
							hand[0][1] == "5" and \
							hand[1][1] == "Ace":
								#if not allowed, then hit
								_double_down()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "4" or \
							hand[0][1] == "4" and \
							hand[1][1] == "Ace":
								#if not allowed, then hit
								_double_down()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "3" or \
							hand[0][1] == "3" and \
							hand[1][1] == "Ace":
								#if not allowed, then hit
								_double_down()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "2" or \
							hand[0][1] == "2" and \
							hand[1][1] == "Ace":
								#if not allowed, then hit
								_double_down()
						"6":
							if hand[0][1] == "Ace" and \
							hand[1][1] == "9" or \
							hand[0][1] == "9" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "8" or \
							hand[0][1] == "8" and \
							hand[1][1] == "Ace":
								#if not allowed, then stand
								_double_down()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "7" or \
							hand[0][1] == "7" and \
							hand[1][1] == "Ace":
								#if not allowed, then stand
								_double_down()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "6" or \
							hand[0][1] == "6" and \
							hand[1][1] == "Ace":
								#if not allowed, then hit
								_double_down()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "5" or \
							hand[0][1] == "5" and \
							hand[1][1] == "Ace":
								#if not allowed, then hit
								_double_down()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "4" or \
							hand[0][1] == "4" and \
							hand[1][1] == "Ace":
								#if not allowed, then hit
								_double_down()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "3" or \
							hand[0][1] == "3" and \
							hand[1][1] == "Ace":
								#if not allowed, then hit
								_double_down()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "2" or \
							hand[0][1] == "2" and \
							hand[1][1] == "Ace":
								#if not allowed, then hit
								_double_down()
						"7":
							if hand[0][1] == "Ace" and \
							hand[1][1] == "9" or \
							hand[0][1] == "9" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "8" or \
							hand[0][1] == "8" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "7" or \
							hand[0][1] == "7" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "6" or \
							hand[0][1] == "6" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "5" or \
							hand[0][1] == "5" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "4" or \
							hand[0][1] == "4" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "3" or \
							hand[0][1] == "3" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "2" or \
							hand[0][1] == "2" and \
							hand[1][1] == "Ace":
								_hit()
						"8":
							if hand[0][1] == "Ace" and \
							hand[1][1] == "9" or \
							hand[0][1] == "9" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "8" or \
							hand[0][1] == "8" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "7" or \
							hand[0][1] == "7" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "6" or \
							hand[0][1] == "6" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "5" or \
							hand[0][1] == "5" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "4" or \
							hand[0][1] == "4" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "3" or \
							hand[0][1] == "3" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "2" or \
							hand[0][1] == "2" and \
							hand[1][1] == "Ace":
								_hit()
						"9":
							if hand[0][1] == "Ace" and \
							hand[1][1] == "9" or \
							hand[0][1] == "9" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "8" or \
							hand[0][1] == "8" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "7" or \
							hand[0][1] == "7" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "6" or \
							hand[0][1] == "6" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "5" or \
							hand[0][1] == "5" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "4" or \
							hand[0][1] == "4" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "3" or \
							hand[0][1] == "3" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "2" or \
							hand[0][1] == "2" and \
							hand[1][1] == "Ace":
								_hit()
						"10":
							if hand[0][1] == "Ace" and \
							hand[1][1] == "9" or \
							hand[0][1] == "9" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "8" or \
							hand[0][1] == "8" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "7" or \
							hand[0][1] == "7" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "6" or \
							hand[0][1] == "6" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "5" or \
							hand[0][1] == "5" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "4" or \
							hand[0][1] == "4" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "3" or \
							hand[0][1] == "3" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "2" or \
							hand[0][1] == "2" and \
							hand[1][1] == "Ace":
								_hit()
						"Jack":
							if hand[0][1] == "Ace" and \
							hand[1][1] == "9" or \
							hand[0][1] == "9" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "8" or \
							hand[0][1] == "8" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "7" or \
							hand[0][1] == "7" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "6" or \
							hand[0][1] == "6" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "5" or \
							hand[0][1] == "5" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "4" or \
							hand[0][1] == "4" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "3" or \
							hand[0][1] == "3" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "2" or \
							hand[0][1] == "2" and \
							hand[1][1] == "Ace":
								_hit()
						"Queen":
							if hand[0][1] == "Ace" and \
							hand[1][1] == "9" or \
							hand[0][1] == "9" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "8" or \
							hand[0][1] == "8" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "7" or \
							hand[0][1] == "7" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "6" or \
							hand[0][1] == "6" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "5" or \
							hand[0][1] == "5" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "4" or \
							hand[0][1] == "4" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "3" or \
							hand[0][1] == "3" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "2" or \
							hand[0][1] == "2" and \
							hand[1][1] == "Ace":
								_hit()
						"King":
							if hand[0][1] == "Ace" and \
							hand[1][1] == "9" or \
							hand[0][1] == "9" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "8" or \
							hand[0][1] == "8" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "7" or \
							hand[0][1] == "7" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "6" or \
							hand[0][1] == "6" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "5" or \
							hand[0][1] == "5" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "4" or \
							hand[0][1] == "4" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "3" or \
							hand[0][1] == "3" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "2" or \
							hand[0][1] == "2" and \
							hand[1][1] == "Ace":
								_hit()
						"Ace":
							if hand[0][1] == "Ace" and \
							hand[1][1] == "9" or \
							hand[0][1] == "9" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "8" or \
							hand[0][1] == "8" and \
							hand[1][1] == "Ace":
								_stand()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "7" or \
							hand[0][1] == "7" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "6" or \
							hand[0][1] == "6" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "5" or \
							hand[0][1] == "5" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "4" or \
							hand[0][1] == "4" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "3" or \
							hand[0][1] == "3" and \
							hand[1][1] == "Ace":
								_hit()
							elif hand[0][1] == "Ace" and \
							hand[1][1] == "2" or \
							hand[0][1] == "2" and \
							hand[1][1] == "Ace":
								_hit()
			else:
				print("Has a pair of " + hand[0][1] + "s")
				match game.dealer_hand[0][1]:
					"2":
						match hand[0][1]:
							"Ace":
								_split()
							"King":
								_stand()
							"Queen":
								_stand()
							"Jack":
								_stand()
							"10":
								_stand()
							"9":
								_split()
							"8":
								_split()
							"7":
								_split()
							"6":
								_split()
							"5":
								#if not allowed, then hit
								_double_down()
							"4":
								_hit()
							"3":
								_split()
							"2":
								_split()
					"3":
						match hand[0][1]:
							"Ace":
								_split()
							"King":
								_stand()
							"Queen":
								_stand()
							"Jack":
								_stand()
							"10":
								_stand()
							"9":
								_split()
							"8":
								_split()
							"7":
								_split()
							"6":
								_split()
							"5":
								#if not allowed, then hit
								_double_down()
							"4":
								_hit()
							"3":
								_split()
							"2":
								_split()
					"4":
						match hand[0][1]:
							"Ace":
								_split()
							"King":
								_stand()
							"Queen":
								_stand()
							"Jack":
								_stand()
							"10":
								_stand()
							"9":
								_split()
							"8":
								_split()
							"7":
								_split()
							"6":
								_split()
							"5":
								#if not allowed, then hit
								_double_down()
							"4":
								_hit()
							"3":
								_split()
							"2":
								_split()
					"5":
						match hand[0][1]:
							"Ace":
								_split()
							"King":
								_stand()
							"Queen":
								_stand()
							"Jack":
								_stand()
							"10":
								_stand()
							"9":
								_split()
							"8":
								_split()
							"7":
								_split()
							"6":
								_split()
							"5":
								#if not allowed, then hit
								_double_down()
							"4":
								_split()
							"3":
								_split()
							"2":
								_split()
					"6":
						match hand[0][1]:
							"Ace":
								_split()
							"King":
								_stand()
							"Queen":
								_stand()
							"Jack":
								_stand()
							"10":
								_stand()
							"9":
								_split()
							"8":
								_split()
							"7":
								_split()
							"6":
								_split()
							"5":
								#if not allowed, then hit
								_double_down()
							"4":
								_split()
							"3":
								_split()
							"2":
								_split()
					"7":
						match hand[0][1]:
							"Ace":
								_split()
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
								_split()
							"7":
								_split()
							"6":
								_hit()
							"5":
								#if not allowed, then hit
								_double_down()
							"4":
								_hit()
							"3":
								_split()
							"2":
								_split()
					"8":
						match hand[0][1]:
							"Ace":
								_split()
							"King":
								_stand()
							"Queen":
								_stand()
							"Jack":
								_stand()
							"10":
								_stand()
							"9":
								_split()
							"8":
								_split()
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
								_split()
							"King":
								_stand()
							"Queen":
								_stand()
							"Jack":
								_stand()
							"10":
								_stand()
							"9":
								_split()
							"8":
								_split()
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
								_split()
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
								_split()
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
								_split()
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
								_split()
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
								_split()
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
								_split()
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
								_split()
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
								_split()
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
								_split()
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
		if standed:
			print(self.name + " has already standed. Skipping turn")
		if doubled_down:
			print(self.name + " has already doubled down, and will not get cards. Skipping turn")
		if surrendered:
			print(self.name + " has surrendered. Skipping turn")
		if blackjack_in_hand:
			print(self.name + " has a blackjack in hand. Skipping turn")
	#game.player_action.start()

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

func _split():
	print(self.name + " splits!")

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
