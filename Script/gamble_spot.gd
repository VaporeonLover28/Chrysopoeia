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

@onready var can_cancel_interact: bool = true

@onready var is_transiting : bool = false

var tween : Tween

func _ready() -> void:
	sit_positions.chosen_sitting_transition = $"Player Chair"
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("e") and sit_positions.player_is_sitting == true and can_cancel_interact == true:
		#world.get_node("Player").object_sitting = null
		#sit_positions.player_is_sitting = false
		#Globals.player_interacting = false
		pass
		
	if Input.is_action_just_pressed("click") and sit_positions.player_is_sitting == true and sit_positions._CNSC() >= 2 and is_transiting == false:
		_transiti_into_bet()
		is_transiting = true
		
	can_cancel_interact = true

func _interact_GambleSpot(object_ref):
	print(object_ref)
	if object_ref.name == "Player":
		print("i don't get it")
		can_cancel_interact = false
		sit_positions.player_is_sitting = true
		Globals.player_interacting = true
		world.get_node("Player").object_sitting = self
		print(Globals.player_interacting)
<<<<<<< Updated upstream
		sit_positions._pull_camera(world.get_node("Player"), sit_positions.get_parent().rotation_degrees)
=======
		sit_positions._pull_camera(world.get_node("Player"))
		_transiti_into_bet()
		
>>>>>>> Stashed changes
	if object_ref is NPC:
		print("interact npc")
		sit_positions._sit_character(object_ref)
	
func _transiti_into_bet():
		await get_tree().create_timer(0.75).timeout
		loading_screen(game_machice_scene)
		for item in sit_positions.chair_postion_list:
			var save_character: Array
			print(item.size() > 3 and item[2] != null)
			if item.size() >= 3 and item[2] != null:
				save_character.push_back(item[2].npc_name)
				save_character.push_back(item[2].money)
				save_character.push_back(item[2].get_index())
				Globals.transiting_characters_to_gamble.push_back(save_character)
		for item in world.get_node("Walking_NPCs").get_children():
			var save_npcs_info : Array
			save_npcs_info.push_back(item.scene_file_path)
			save_npcs_info.push_back(item.global_position)
			print(item.global_position)
			save_npcs_info.push_back(item.get_index())
			save_npcs_info.push_back(item.money)
			Globals.save_npcs_pos.push_back(save_npcs_info)
		for item in 2:
			var node_to_get
			match item:
				0:
					node_to_get = world.all_interactable_spots
				1:
					node_to_get = world.all_non_interactable_objects
			for object in node_to_get.get_children():
				var save_object_info: Array
				save_object_info.push_back(object.scene_file_path)
				save_object_info.push_back(object.global_position)
				save_object_info.push_back(object.rotation)
				Globals.save_objects.push_back(save_object_info)
		var array_of_building_spot: Array
		for item in world.get_node("All Build spots").get_children():
			array_of_building_spot.push_back(item.taken)
		Globals.save_build_spot.push_back(array_of_building_spot)
		Globals.save_player_pos = world.get_node("Player").global_position

func _cancel_interact_GambleSpot(object_ref):
	sit_positions._stand_character_up(object_ref)
	
func loading_screen(game):
	Globals.player_pos_save = player_ref.global_position
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
	get_tree().change_scene_to_file("res://Scenes/" + game + ".tscn")
