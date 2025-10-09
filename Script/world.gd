extends Node3D

@onready var tut_panel = preload("res://Scenes/tutorial_panel.tscn")
@onready var npc = preload("res://Scenes/npc.tscn")
@onready var player: CharacterBody3D = $Player
@onready var walking_npcs: Node = $Walking_NPCs
@onready var all_interactable_spots: Node = $"NavigationRegion3D/All Interactable Spots"
@onready var all_non_interactable_objects: Node = $"NavigationRegion3D/All non interactable objects"
@onready var npc_spwaner_timer: Timer = $"NPC Spwaner Timer"
@onready var player_recon: Area3D = $NavigationRegion3D/cassino/fight_ring/player_recon
@onready var tutorial: CanvasLayer = $Tutorial

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
signal query
signal shop_tutorial

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
			player.global_position = new_config.get_value("Player", "position")
			## proxima linha é só pra testar
			for item in $"All Build spots".get_children():
				item.taken = new_config.get_value("Scene", "build_spot")[item.get_index()]
				
			for item in new_config.get_value("NPC", "info"):
				var instantiate_npc = load(item[0]).instantiate()
				instantiate_npc.global_position = item[1]
				walking_npcs.add_child(instantiate_npc)
				walking_npcs.get_child(-1).money = item[2]
			
			if new_config.get_value("Globalvaribles", "tutorials")["open_shop"]:
				$HUD/money_box.visible = true
				$HUD/money_box/shop/keybind.visible = true
				$HUD/money_box/shop/keybind.position = Vector2(15, 58)
			
			$NavigationRegion3D.bake_navigation_mesh()
			SaveScript.is_loading = false
			SaveScript.current_savefile_loading = ""
			$Walking_NPCs/NPC.queue_free()
			$Walking_NPCs/NPC2.queue_free()
	elif Globals.save_npcs_pos.is_empty() != true and Globals.save_objects.is_empty() != true:
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
		for item in all_interactable_spots.get_children():
			item.taken = Globals.save_build_spot[item.get_index()]
			
		SaveScript.auto_save.emit()
		$Walking_NPCs/NPC.queue_free()
		$Walking_NPCs/NPC2.queue_free()
		$NavigationRegion3D.bake_navigation_mesh()
	
	Globals.transiting_characters_to_gamble = []
	Globals.save_npcs_pos = []
	Globals.save_objects = []
	Globals.save_player_pos = Vector3()
	Globals.save_build_spot = []
	
	if !TutorialManager.tutorials["movement"]:
		await get_tree().create_timer(1).timeout
		var tut_query = tut_panel.instantiate()
		tut_query.dis_time = 9999
		tut_query.vec_size = Vector2(200, 50)
		#tut_query.pos = Vector2(930, 270)
		tut_query.panel_type = 0
		tut_query.text = "Load tutorial?\nPress Y to load or N to skip all tutorials."
		tutorial.add_child(tut_query)
		
		await self.query
		
		tut_query.queue_free()
		await get_tree().create_timer(0.5).timeout
		var tut_inst = tut_panel.instantiate()
		tut_inst.tutorial = "movement"
		tut_inst.dis_time = 15.0
		tut_inst.vec_size = Vector2(200, 173)
		#tut_inst.pos = Vector2(930, 260)
		tut_inst.panel_type = 0
		tut_inst.text = "Thank you for purchasing the deed to Chrysopoeia " +\
		"Tavern! The place is all yours.\n\nWalk around using WASD and explore!"
		tutorial.add_child(tut_inst)
		
		await get_tree().create_timer(16).timeout
		
		$"HUD/money_box".visible = true
		var tut_inst2 = tut_panel.instantiate()
		tut_inst2.tutorial = "open_shop"
		tut_inst2.dis_time = 9999
		tut_inst2.vec_size = Vector2(200, 203)
		#tut_inst2.pos = Vector2(890, 250)
		tut_inst2.panel_type = 1
		tut_inst2.text = "This place is big, but still empty. This way " +\
		"nobody's gonna come here."
		tut_inst2.key = load("res://Assets/Exports/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_b_outline.png")
		tut_inst2.key_text = "shop"
		tutorial.add_child(tut_inst2)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("z"):
		SaveScript._save_function(self, 0)
	if Input.is_action_just_pressed("x"):
		SaveScript._load_function(0)
	if Input.is_action_just_pressed("y") and !TutorialManager.tutorials["movement"]:
		query.emit()
	if Input.is_action_just_pressed("n") and !TutorialManager.tutorials["movement"]:
		if !tutorial.get_child_count() == 0:
			tutorial.get_child(0).queue_free()
		$"HUD/money_box".visible = true
		$HUD/money_box/shop/keybind.visible = true
		$HUD/money_box/shop/keybind.position = Vector2(15, 58)
		for key in TutorialManager.tutorials:
			TutorialManager.tutorials[key] = true

func _exit_tree() -> void:
	SaveScript.auto_save.disconnect(SaveScript._save_function)

func _spawn_npc():
	is_trying_to_spawn_npc = true
	while is_trying_to_spawn_npc == true:
		var NPC_to_spawn = npc_list.pick_random().instantiate()
		
		if NPC_to_spawn.scene_file_path == "res://Scenes/mage.tscn" and \
		_see_number_of_NPC_type(NPC_to_spawn.scene_file_path) < maximum_number_of_mages:
			walking_npcs.add_child(NPC_to_spawn)
			NPC_to_spawn.position = Vector3(0,0.5,0)
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
			
	npc_spwaner_timer.start(randf_range(minimum_time_for_spawn_npc, maximum_time_for_spawn_npc)/(Globals.satisfaction_level + 100)/200)
		
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

func _on_shop_tutorial() -> void:
	tutorial.get_child(0).clear()
	$HUD/money_box/shop/keybind.visible = true
	$HUD/money_box/shop/keybind.position = Vector2(15, 58)
	var tut_inst = tut_panel.instantiate()
	tut_inst.tutorial = "shop"
	tut_inst.dis_time = 9999
	tut_inst.vec_size = Vector2(200, 50)
	#tut_inst.pos = Vector2(930, 270)
	tut_inst.panel_type = 0
	tut_inst.text = "It's time to renovate!\n\nBuy a slot machine to start this place up.\n" +\
	"Press the button below an item to begin placing it."
	tutorial.add_child(tut_inst)

func _on_player_build_tutorial() -> void:
	tutorial.get_child(0).clear()
	var tut_inst = tut_panel.instantiate()
	tut_inst.tutorial = "build"
	tut_inst.dis_time = 9999
	tut_inst.vec_size = Vector2(200, 50)
	#tut_inst.pos = Vector2(900, 200)
	tut_inst.panel_type = 1
	tut_inst.text = "Bring the item to a valid build spot,\nmarked by the green areas on the ground," +\
	" to build it.\n\nYou can rotate the item by holding Q or E."
	tut_inst.key = load("res://Assets/Exports/kenney_input-prompts_1.4/Keyboard & Mouse/Default/mouse_right_outline.png")
	tut_inst.key_text = "place"
	tutorial.add_child(tut_inst)

func _on_player_slot_machine_tutorial() -> void:
	tutorial.get_child(0).clear()
	var tut_inst = tut_panel.instantiate()
	tut_inst.tutorial = "slot_machine1"
	tut_inst.dis_time = 9999
	tut_inst.vec_size = Vector2(200, 50)
	#tut_inst.pos = Vector2(900, 230)
	tut_inst.panel_type = 1
	tut_inst.text = "Put 30 gold in the machine to spin it.\n\nSlot machines "+\
	"have six different symbols, each one rarer than the other."
	tut_inst.key = load("res://Assets/Exports/kenney_input-prompts_1.4/Keyboard & Mouse/Default/keyboard_e_outline.png")
	tut_inst.key_text = "play"
	tutorial.add_child(tut_inst)
