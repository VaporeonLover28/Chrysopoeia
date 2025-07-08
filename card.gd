extends Node3D

#@export_enum("Ace", "Two", "Three", "Four", "Five", "Six", \
#"Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King") var rank : String = "Ace"
@export_enum("A", "2", "3", "4", "5", "6", "7", "8", "9", \
"10", "J", "Q", "K") var value : String = "A"
@export_enum("Clubs", "Hearts", "Spades", "Diamonds") var suit : String = "Spades"

@onready var club = preload("res://Clubs.tscn")
@onready var heart = preload("res://Hearts.tscn")
@onready var spade = preload("res://Spades.tscn")
@onready var diamond = preload("res://Diamonds.tscn")

@onready var mesh_value: MeshInstance3D = $value1
@onready var suitmarkers: Node3D = $cardinfo/suitmarkers
@onready var cardsuits: Node3D = $cardinfo/suits
var marker_array : Array

var rank_suit_size = 0.16
var box_suit_size = 0.13

#Markers each rank uses for the suits on the card:
#Ace: 1
#Two: 2, 3
#Three: 1, 2, 3
#Four: 4, 5, 6, 7
#Five: 1, 4, 5, 6, 7
#Six: 4, 5, 6, 7, 8, 9
#Seven: 4, 5, 6, 7, 8, 9, 11
#Eight: 4, 5, 6, 7, 8, 9, 10, 11
#Nine: 1, 4, 5, 6, 7, 12, 13, 14, 15
#Ten: 4, 5, 6, 7, 10, 11, 12, 13, 14, 15

func _ready() -> void:
	#print(str(value) + " of " + str(suit))
	#for each child in suitmarkers, excluding rankmarkers
	for child in suitmarkers.get_child_count() - 2:
		#push back the marker (jumping two forward for the exclusion) to the marker array
		marker_array.push_back(suitmarkers.get_child(child + 2))
		#print(marker_array)
	#Changes the card visuals to a default Ace of Clubs (should be called again in instancing)

#Changes the card values according to the called parameters
func _change_values(new_suit, new_value):
	#rank = new_rank
	suit = new_suit
	value = new_value
	print("Changed to " + str(value) + " of " + str(suit))
	#Updates the card visuals to the new card values
	_change_card_visuals()

func _change_card_visuals():
	#Updates the value textmesh to the value
	#Changes both of the value meshes, even called in just one, because they are duplicates
	mesh_value.mesh.text = value
	
	#Black suits make the card black, red makes red.
	if suit == "Clubs" or suit == "Spades":
		mesh_value.mesh.material = load("res://albedo_black.tres")
		print("Is a black card")
	else:
		mesh_value.mesh.material = load("res://albedo_red.tres")
		print("Is a red card")
	
	#Makes the box mesh the same color as the card's suit
	$cardinfo/box/wall1.mesh.material = mesh_value.mesh.material
	$cardinfo/box/wall3.mesh.material = mesh_value.mesh.material
	
	#new array to choose which markers to use when placing box suits
	var which_suits : Array
	#if not a face card
	if value != "J" and value != "Q" and value != "K":
		#chooses the markers
		match value:
			"A":
				which_suits = [1]
			"2":
				which_suits = [2, 3]
			"3":
				which_suits = [1, 2, 3]
			"4":
				which_suits = [4, 5, 6, 7]
			"5":
				which_suits = [1, 4, 5, 6, 7]
			"6":
				which_suits = [4, 5, 6, 7, 8, 9]
			"7":
				which_suits = [4, 5, 6, 7, 8, 9, 11]
			"8":
				which_suits = [4, 5, 6, 7, 8, 9, 10, 11]
			"9":
				which_suits = [1, 4, 5, 6, 7, 12, 13, 14, 15]
			"10":
				which_suits = [4, 5, 6, 7, 10, 11, 12, 13, 14, 15]
		print(which_suits)
		#for how many suits to place
		for how_many_suits in which_suits.size():
			var new_suit : PackedScene
			#picks the suit
			match suit:
				"Clubs":
					new_suit = club
				"Hearts":
					new_suit = heart
				"Spades":
					new_suit = spade
				"Diamonds":
					new_suit = diamond
			#instantiates it in the marker's position with the marker's rotation
			var inst_suit = new_suit.instantiate()
			inst_suit.global_position = marker_array[which_suits[how_many_suits] - 1].global_position
			inst_suit.rotation_degrees.y = marker_array[which_suits[how_many_suits] - 1].rotation_degrees.y
			#print(which_suits[how_many_suits])
			#print(marker_array[which_suits[how_many_suits] - 1].name)
			#makes it the same color as the suit
			inst_suit.mesh.material = mesh_value.mesh.material
			#makes it face up
			inst_suit.rotation_degrees.x = -90
			#makes it small
			inst_suit.scale = Vector3(box_suit_size, box_suit_size, box_suit_size)
			cardsuits.add_child(inst_suit)
	else:
		print("Is a face card")
		var new_suit : PackedScene
		#picks the suit
		match suit:
			"Clubs":
				new_suit = club
			"Hearts":
				new_suit = heart
			"Spades":
				new_suit = spade
			"Diamonds":
				new_suit = diamond
		#instantiates it in the marker's position with the marker's rotation
		var inst_suit = new_suit.instantiate()
		inst_suit.global_position = marker_array[0].global_position
		inst_suit.rotation_degrees.y = marker_array[0].rotation_degrees.y
		#print(which_suits[how_many_suits])
		#print(marker_array[which_suits[how_many_suits] - 1].name)
		#makes it the same color as the suit
		inst_suit.mesh.material = mesh_value.mesh.material
		#makes it face up
		inst_suit.rotation_degrees.x = -90
		#makes it small
		inst_suit.scale = Vector3(rank_suit_size, rank_suit_size, rank_suit_size)
		cardsuits.add_child(inst_suit)
	#changes the visuals for the rank meshes
	_change_rank_visuals()

#changes the visuals for the rank meshes
func _change_rank_visuals():
	var rank_suit : PackedScene
	#picks the current card suit
	match suit:
		"Clubs":
			rank_suit = club
		"Hearts":
			rank_suit = heart
		"Spades":
			rank_suit = spade
		"Diamonds":
			rank_suit = diamond
	#instantiates it in the first marker
	var inst_rank_suit = rank_suit.instantiate()
	inst_rank_suit.global_position = $cardinfo/suitmarkers/rankmarker1.global_position
	#with the current suit color
	inst_rank_suit.mesh.material = mesh_value.mesh.material
	#makes it face up
	inst_rank_suit.rotation_degrees.x = -90
	#and small
	inst_rank_suit.scale = Vector3(rank_suit_size, rank_suit_size, rank_suit_size)
	cardsuits.add_child(inst_rank_suit)
	#same thing in the second marker
	var inst_rank_suit2 = rank_suit.instantiate()
	inst_rank_suit2.global_position = $cardinfo/suitmarkers/rankmarker2.global_position
	inst_rank_suit2.mesh.material = mesh_value.mesh.material
	inst_rank_suit2.rotation_degrees.x = -90
	#upside down
	inst_rank_suit2.rotation_degrees.y = 180
	inst_rank_suit2.scale = Vector3(rank_suit_size, rank_suit_size, rank_suit_size)
	cardsuits.add_child(inst_rank_suit2)
