extends Node3D

@onready var npc = preload("res://npc.tscn")
@onready var player: CharacterBody3D = $Player
@onready var walking_npcs: Node = $Walking_NPCs
@onready var all_interactable_spots: Node = $"NavigationRegion3D/All Interactable Spots"

func _ready() -> void:
	var new_config = ConfigFile.new()
	print(SaveScript.current_savefile_loading + "oi")
	print($"NavigationRegion3D/All Interactable Spots")
	if SaveScript.current_savefile_loading != "":
		var loading = new_config.load(SaveScript.current_savefile_loading)
		if loading == OK:
			for item in new_config.get_value("Scene", "interactable object count"):
				var instantiate_interactable = load(new_config.get_value("Scene", "interactable")[item][0]).instantiate()
				instantiate_interactable.global_position = new_config.get_value("Scene", "interactable")[item][1]
				all_interactable_spots.add_child(instantiate_interactable)
			print(new_config.get_value("Player", "position"))
			player.global_position = new_config.get_value("Player", "position")
			for item in new_config.get_value("NPC", "count") - 1:
				var instantiate_npc = npc.instantiate()
				instantiate_npc.global_position = new_config.get_value("NPC", "position")[item]
				walking_npcs.add_child(instantiate_npc)
		else:
			return
	else:
		print("não loudou")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("z"):
		SaveScript._save_function(self, 0)
	if Input.is_action_just_pressed("x"):
		SaveScript._load_function(self, 0)
