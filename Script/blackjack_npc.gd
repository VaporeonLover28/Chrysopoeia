extends CharacterBody3D

@onready var nav: NavigationAgent3D = $nav
@onready var hand_marker: Marker3D = $hand
@onready var action_label: Label3D = $action_label

@export_enum("Pleb", "Mage", "Guard", "Noble", "Joker" ) var type : String = "Noble"
@export_enum("Playing", "Standed", "Busted", "Surrendered", "Blackjack", "Doubled") var state : String = "Playing"

var assigned_chair : bool = false
var is_sat_down : bool = false

var assigned_gc_label : RichTextLabel
var hand : Array = []
var hand_value : int = 0

func _process(delta: float) -> void:
	if is_sat_down == false:
		var destination = nav.get_next_path_position()
		var local_destination = destination - global_position
		var dir = local_destination.normalized()
		velocity = dir * 2
		look_at(transform.basis.z * -1)
		rotation.x = 0
		rotation.z = 0
	elif velocity != Vector3.ZERO:
		velocity = Vector3.ZERO
		#_look_at_player()
	
	move_and_slide()

func update_gc_label():
	assigned_gc_label.text = "Player " + name + "\nAI: " + \
	str(type) + "\nValue: " + str(hand_value) + "\nHand:\n"
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
