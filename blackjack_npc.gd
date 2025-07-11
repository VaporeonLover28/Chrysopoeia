extends CharacterBody3D

@onready var nav: NavigationAgent3D = $nav
@onready var hand_marker: Marker3D = $hand

@export_enum("Pleb", "Mage", "Guard", "Noble", "Joker" ) var type : String = "Noble"

var assigned_chair : bool = false
var is_sat_down : bool = false

var assigned_gc_label : RichTextLabel
var hand1 : Array = []

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
	str(type) + "\nHand1: " + str(hand1)

func go_to_table(chair_pos):
	#print(chair_pos)
	nav.set_target_position(chair_pos)

func _on_nav_navigation_finished() -> void:
	is_sat_down = true

func look_at_player():
	look_at($"../bj_player_test".position)
	rotation.x = 0
	rotation.z = 0
