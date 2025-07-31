extends Node3D

@export_enum("Ace", "Two", "Three", "Four", "Five", "Six", \
"Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King") var rank : String = "Ace"
@export_enum("A", "2", "3", "4", "5", "6", "7", "8", "9", \
"10", "J", "Q", "K") var value : String = "A"
@export_enum("Clubs", "Hearts", "Spades", "Diamonds") var suit : String = "Spades"

@onready var card_texture: Sprite3D = $card_texture
@onready var backmesh: Sprite3D = $backmesh

var chosen_rank : String
var chosen_value : String
var chosen_suit : String

#Changes the card values according to the called parameters
func change_values(new_rank, new_suit, new_value):
	rank = new_rank
	suit = new_suit
	value = new_value
	$card_texture.set_texture(load("res://Assets/card_textures/" + str(rank.to_lower()) +"_of_" + str(suit.to_lower()) + ".png"))
	#print("Changed to " + str(rank.to_lower()) + " of " + str(suit.to_lower()))

func _on_tree_entered() -> void:
	change_values(chosen_rank, chosen_suit, chosen_value)
