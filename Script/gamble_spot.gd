extends InteractableObject; class_name GambleSpot

#@onready var mat = self.material
@onready var world: Node3D = $"../../.."
@onready var camera: Camera3D = $camera
@onready var sit_positions: Node = $"Sit positions"

#put file reference of the wanted game that you want to change to
@export var game_machice_scene : String
# other vars
var blackjack_npc = preload("res://Scenes/blackjack_npc.tscn")
@onready var player_ref = $"../../../Player"
# Called when the node enters the scene tree for the first time.
func _interact_GambleSpot(object_ref):
	sit_positions._sit_characther(object_ref)
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("e") and sit_positions.player_is_sitting == true:
		_cancel_interact_GambleSpot(sit_positions.save_player_ref)

func _cancel_interact_GambleSpot(object_ref):
	sit_positions._stand_characther_up(object_ref)

func _start_game():
	get_tree().change_scene_to_file(game_machice_scene)
