extends Node3D

@onready var npc = preload("res://Scenes/npc.tscn")
@onready var player: CharacterBody3D = $Player
@onready var walking_npcs: Node = $Walking_NPCs
@onready var all_interactable_spots: Node = $"NavigationRegion3D/All Interactable Spots"
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
preload("res://Scenes/knight.tscn"), \
preload("res://Scenes/jester.tscn"), \
preload("res://Scenes/communer.tscn"), \
preload("res://Scenes/noble.tscn")]

func _ready() -> void:
	npc_spwaner_timer.start(randf_range(minimum_time_for_spawn_npc, maximum_time_for_spawn_npc))
	var new_config = ConfigFile.new()
	if SaveScript.current_savefile_loading != "":
		var loading = new_config.load(SaveScript.current_savefile_loading)
		if loading == OK:
			for item in new_config.get_value("Scene", "interactable object count"):
				var instantiate_interactable = load(new_config.get_value("Scene", "interactable")[item][0]).instantiate()
				instantiate_interactable.global_position = new_config.get_value("Scene", "interactable")[item][1]
				instantiate_interactable.rotation = new_config.get_value("Scene", "interactable")[item][2]
				all_interactable_spots.add_child(instantiate_interactable)
			print(new_config.get_value("Player", "position"))
			player.global_position = new_config.get_value("Player", "position")
			for item in new_config.get_value("NPC", "count") - 1:
				var instantiate_npc = npc.instantiate()
				instantiate_npc.global_position = new_config.get_value("NPC", "position")[item]
				walking_npcs.add_child(instantiate_npc)
		else:
			return

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("z"):
		SaveScript._save_function(self, 0)
	if Input.is_action_just_pressed("x"):
		SaveScript._load_function(self, 0)
		
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
	return npc_type_count
	
