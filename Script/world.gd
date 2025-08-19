extends Node3D

@onready var npc = preload("res://Scenes/npc.tscn")
@onready var player: CharacterBody3D = $Player
@onready var walking_npcs: Node = $Walking_NPCs
@onready var all_interactable_spots: Node = $"NavigationRegion3D/All Interactable Spots"
@onready var all_non_interactable_objects: Node = $"NavigationRegion3D/All non interactable objects"
@onready var npc_spwaner_timer: Timer = $"NPC Spwaner Timer"
@onready var player_recon: Area3D = $NavigationRegion3D/cassino/fight_ring/player_recon

var is_trying_to_spawn_npc: bool = false

@export var maximum_number_of_mages: int = 2
@export var maximum_number_of_knights: int = 2
@export var maximum_number_of_jesters: int = 2
@export var maximum_number_of_communers: int = 2
@export var maximum_number_of_nobles: int = 2
@export var maximum_number_of_alcoholic_mages: int = 2

@export var minimum_time_for_spawn_npc: float
@export var maximum_time_for_spawn_npc: float

var npc_list: Array[PackedScene] = [preload("res://Scenes/mage.tscn"),\
preload("res://Scenes/guard.tscn"), \
preload("res://Scenes/joker.tscn"), \
preload("res://Scenes/pleb.tscn"), \
preload("res://Scenes/noble.tscn")]

signal update_all_mesh

func _ready() -> void:
	Globals.limit_spells(["Wheel of Fortune"])
	Globals.is_betting = false
	SaveScript.auto_save.connect(SaveScript._save_function.bind(self, 0))
	npc_spwaner_timer.start(randf_range(minimum_time_for_spawn_npc, maximum_time_for_spawn_npc))
	var new_config = ConfigFile.new()
	MusicPlayer.emptytavern.play()
	if SaveScript.current_savefile_loading != "":
		var loading = new_config.load(SaveScript.current_savefile_loading)
		if loading == OK:
			var count_1 : int = 0
			var count_2 : int = 0
			for item in new_config.get_value("Scene", "non interactable"):
				var instantiate_interactable = load(item[0]).instantiate()
				all_non_interactable_objects.add_child(instantiate_interactable)
				instantiate_interactable.global_position = item[1]
				instantiate_interactable.rotation = item[2]
				
			for item in new_config.get_value("Scene", "interactable"):
				var instantiate_interactable = load(item[0]).instantiate()
				all_non_interactable_objects.add_child(instantiate_interactable)
				instantiate_interactable.global_position = item[1]
				instantiate_interactable.rotation = item[2]
			print(new_config.get_value("Player", "position"))
			player.global_position = new_config.get_value("Player", "position")
			#print(new_config.get_value("NPC", "info"))
			## proxima linha é só pra testar	
			$Walking_NPCs/NPC.queue_free()
			for item in new_config.get_value("NPC", "info"):
				var instantiate_npc = load(item[0]).instantiate()
				instantiate_npc.global_position = item[1]
				walking_npcs.add_child(instantiate_npc)
				walking_npcs.get_child(-1).money = item[2]
				print(walking_npcs.get_child(-1).money)
			SaveScript.is_loading = false
	elif Globals.save_npcs_pos.is_empty() != true and Globals.save_objects.is_empty() != true:
		$Walking_NPCs/NPC.queue_free()
		var counter: int = 0
		for item in Globals.save_npcs_pos:
			var instantiate_npc = load(item[0]).instantiate()
			instantiate_npc.global_position = item[1]
			walking_npcs.add_child(instantiate_npc)
			if Globals.transiting_characters_to_gamble.is_empty() != true and \
			walking_npcs.get_child(-1).get_index() == Globals.transiting_characters_to_gamble[counter][2]:
					walking_npcs.get_child(-1).money == Globals.transiting_characters_to_gamble[counter][1]
			else: 
				walking_npcs.get_child(-1).money = Globals.save_npcs_pos[counter][3]
			counter =+ 1
		for item in Globals.save_objects:
			var instantiate_object = load(item[0]).instantiate()
			instantiate_object.global_position = item[1]
			instantiate_object.rotation = item[2]
			if instantiate_object is InteractableObject:
				all_interactable_spots.add_child(instantiate_object)
			else:
				all_non_interactable_objects.add_child(instantiate_object)
		print(Globals.save_player_pos)
		SaveScript.auto_save.emit()
	Globals.transiting_characters_to_gamble = []
	Globals.save_npcs_pos = []
	Globals.save_objects = []
	Globals.save_player_pos = Vector3()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("z"):
		SaveScript._save_function(self, 0)
	if Input.is_action_just_pressed("x"):
		SaveScript._load_function(0)
 	
func _spawn_npc():
	is_trying_to_spawn_npc = true
	while is_trying_to_spawn_npc == true:
		var NPC_to_spawn = npc_list.pick_random().instantiate()
		
		if NPC_to_spawn.scene_file_path == "res://Scenes/mage.tscn" and \
		_see_number_of_NPC_type(NPC_to_spawn.scene_file_path) < maximum_number_of_mages:
			NPC_to_spawn.position = Vector3(0,0.5,0)
			walking_npcs.add_child(NPC_to_spawn)
			is_trying_to_spawn_npc = false
			
		if NPC_to_spawn.scene_file_path == "res://Scenes/knight.tscn" and \
		_see_number_of_NPC_type(NPC_to_spawn.scene_file_path) < maximum_number_of_knights:
			NPC_to_spawn.position = Vector3(0,0.5,0)
			walking_npcs.add_child(NPC_to_spawn)
			is_trying_to_spawn_npc = false
			
		if NPC_to_spawn.scene_file_path == "res://Scenes/jester.tscn" and \
		_see_number_of_NPC_type(NPC_to_spawn.scene_file_path) < maximum_number_of_jesters:
			NPC_to_spawn.position = Vector3(0,0.5,0)
			walking_npcs.add_child(NPC_to_spawn)
			is_trying_to_spawn_npc = false
			
		if NPC_to_spawn.scene_file_path == "res://Scenes/communer.tscn" and \
		_see_number_of_NPC_type(NPC_to_spawn.scene_file_path) < maximum_number_of_communers:
			NPC_to_spawn.position = Vector3(0,0.5,0)
			walking_npcs.add_child(NPC_to_spawn)
			is_trying_to_spawn_npc = false
			
		if NPC_to_spawn.scene_file_path == "res://Scenes/noble.tscn" and \
		_see_number_of_NPC_type(NPC_to_spawn.scene_file_path) < maximum_number_of_nobles:
			NPC_to_spawn.position = Vector3(0,0.5,0)
			walking_npcs.add_child(NPC_to_spawn)
			is_trying_to_spawn_npc = false
			
		if NPC_to_spawn.scene_file_path == "res://Scenes/alcoholic_mage.tscn" and \
		_see_number_of_NPC_type(NPC_to_spawn.scene_file_path) < maximum_number_of_alcoholic_mages:
			NPC_to_spawn.position = Vector3(0,0.5,0)
			walking_npcs.add_child(NPC_to_spawn)
			is_trying_to_spawn_npc = false
			
	npc_spwaner_timer.start(randf_range(minimum_time_for_spawn_npc, maximum_time_for_spawn_npc))
		
func _see_number_of_NPC_type(npc_type: String):
	var npc_type_count: int  = 0
	for npcs in walking_npcs.get_children():
		if npcs.scene_file_path == npc_type:
			npc_type_count += 1
	if npc_type_count >= 3:
		MusicPlayer.fulltavern.play()
	else:
		MusicPlayer.emptytavern.play()
		
	return npc_type_count
