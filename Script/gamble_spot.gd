extends InteractableObject; class_name GambleSpot

#@onready var mat = self.material
@onready var world: Node3D = $"../../.."
@onready var sit_positions: Node = $"Sit positions"
const LOADING_SUIT = preload("res://Scenes/loading_suit.tscn")
#put file reference of the wanted game that you want to change to
@export var game_machice_scene : String
# other vars
var blackjack_npc = preload("res://Scenes/blackjack_npc.tscn")
@onready var player_ref = $"../../../Player"

var tween : Tween

# Called when the node enters the scene tree for the first time.
func _interact_GambleSpot(object_ref):
	sit_positions._sit_characther(object_ref)
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("e") and sit_positions.player_is_sitting == true:
		_cancel_interact_GambleSpot(sit_positions.save_player_ref)

func _cancel_interact_GambleSpot(object_ref):
	sit_positions._stand_characther_up(object_ref)

func _start_game():
	#loading_screen()
	get_tree().change_scene_to_file(game_machice_scene)
	
func loading_screen():
	var which_suit = randi_range(0, 3)
	var inst = LOADING_SUIT.instantiate()
	match which_suit:
		0:
			inst.text += "♠"
		1:
			inst.text += "♣"
		2:
			inst.text += "♥"
		3:
			inst.text += "♦"
	player_ref.ui.add_child(inst)
	inst.rotation = 0
	inst.scale = Vector2(0.05, 0.05)
	inst.position = Vector2(531.0, 234.0)
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(inst, "scale", Vector2(1.0, 1.0), 1)
	tween.tween_interval(0.5)
	tween.set_ease(Tween.EASE_IN)
	tween.set_parallel(true)
	tween.tween_property(inst, "scale", Vector2(27.0, 27.0), 3)
	tween.tween_property(inst, "rotation_degrees", 90, 3)
	tween.tween_property(inst, "position", Vector2(628.0, 223.0), 3)
	tween.set_parallel(false)
	await get_tree().create_timer(4.5).timeout
	##muda a cena para o callable scene
