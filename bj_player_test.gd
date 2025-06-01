extends Control

@onready var label_hand: RichTextLabel = $BoxContainer/VBoxContainer/hand/RichTextLabel
@onready var game: Control = $".."
@onready var value: Label = $BoxContainer/VBoxContainer/value/Label

var hand : Array = []
var hand_value : int = 0
var standed = false
var busted = false
var blackjack_in_hand = false

#personalities defining how the AI plays
var personality : String
#personality, weight of being chosen
var personality_list : Array = [["Strategic", 70], ["Coward", 90], ["Noob", 100]]

func _process(delta: float) -> void:
	label_hand.text = str(hand)
	value.text = "Value: " + str(hand_value)

#func _act():
	#if standed != true and busted != true and blackjack_in_hand != true:
		#if personality == "Strategic":
			#if hand_value >= 22:
				#_bust()
			#if hand_value == 21:
				#if typeof(hand[0][1]) == 4 and hand[0][1] == "Ace" \
				#or typeof(hand[1][1]) == 4 and hand[1][1] == "Ace":
					#if hand
						#_blackjack()
			

func _stand():
	print(str(self) + " stands.")
	standed = true

func _blackjack():
	print(str(self) + " has a blackjack!")
	blackjack_in_hand = true

func _bust():
	print(str(self) + " busted!")
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
