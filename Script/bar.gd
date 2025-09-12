extends InteractableObject

@onready var world: Node3D = $"../../.."
@onready var camera: Camera3D = $camera
@onready var chair: Marker3D = $"Sit positions 2/Marker3D"

var tween: Tween
var player_ref: CharacterBody3D
var is_occupied: bool = false
var is_player_sitting: bool = false

const MAGO_BAR = preload("res://Scenes/mago_bar.tscn")
const DRINK_PRICES = [25, 80, 120, 100]

signal bought_bar

func _ready() -> void:
	# Spawn bar if unlocked
	if Globals.bar_unlock:
		_spawn_bar()

func _interact(pass_interact_parameter: Array = []):
	if pass_interact_parameter.size() > 0 and pass_interact_parameter[0] is Object:
		var object_ref = pass_interact_parameter[0]
		if object_ref.name == "Player":
			_handle_player_interaction(object_ref)
		else:
			_handle_npc_interaction()
	else:
		# Fallback if no object reference provided
		_handle_npc_interaction()

func _handle_player_interaction(player: CharacterBody3D):
	player.can_move = false
	
	if is_occupied:
		return  # Chair already taken
	
	is_player_sitting = true
	is_occupied = true
	Globals.player_interacting = true
	
	# Move player to chair position
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_parallel(true)
	tween.tween_property(player, "global_position", chair.global_position, 1)
	tween.tween_property(player.camera, "rotation_degrees", Vector3.ZERO, 1)
	tween.tween_property(player.pivot, "rotation_degrees", Vector3.ZERO, 1)
	tween.set_parallel(false)
	
	# Show bar UI after sitting
	if Globals.bar_unlock:
		tween.tween_callback(func(): world.get_node("Bar UI").get_child(0).show_bar_ui(self, player))

func _handle_npc_interaction():
	# NPC buys a random drink
	if not is_occupied:  # Only serve if chair is free
		var random_drink = DRINK_PRICES[randi() % DRINK_PRICES.size()]
		Globals.money += random_drink
		is_occupied = true  # NPC occupies the chair

func _cancel_interact(pass_interact_parameter: Array = []):
	if pass_interact_parameter.size() > 0 and pass_interact_parameter[0] is Object:
		var object_ref = pass_interact_parameter[0]
		_stand_up_player(object_ref)
	else:
		# Handle case where no object reference provided
		if player_ref:
			_stand_up_player(player_ref)

func _stand_up_player(player: CharacterBody3D):
	Globals.player_interacting = false
	is_player_sitting = false
	is_occupied = false
	player_ref = null

func _spawn_bar():
	var mage_instance = MAGO_BAR.instantiate()
	add_child(mage_instance)
	mage_instance.position = Vector3(0, -0.5, -1.1)

func _on_bought_bar():
	_spawn_bar()

# Helper functions for external queries
func is_chair_available() -> bool:
	return not is_occupied

func get_occupant() -> CharacterBody3D:
	return player_ref if is_player_sitting else null
