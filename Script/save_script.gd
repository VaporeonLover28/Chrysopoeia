extends Node

var current_savefile_loading: String
var new_config : ConfigFile

func _init() -> void:
	new_config = ConfigFile.new()

func _save_function(world_scene: Node3D, save_file_number: int):
	new_config.set_value("Globalvaribles", "money", Globals.money)
	new_config.set_value("Globalvaribles", "spells", Globals.spell_inventory_list)
	new_config.set_value("Globalvaribles", "Aqua Vitae Timer", Globals.aqua_vitae_timer.time_left)
	new_config.set_value("Globalvaribles", "Aqua Fortis Active", Globals.aqua_fortis_active)
	new_config.set_value("Globalvaribles", "Aqua Regia Timer", Globals.aqua_regia_timer.time_left)
	new_config.set_value("Globalvaribles", "Aqua Philosophorum Timer", Globals.aqua_philosophorum_timer.time_left)
	new_config.set_value("Scene", "World Scene", world_scene.scene_file_path)
	new_config.set_value("Scene", "interactable object count",\
	world_scene.get_node("NavigationRegion3D/All Interactable Spots").get_child_count())
	var array_obj_interact : Array
	for item in world_scene.get_node("NavigationRegion3D/All Interactable Spots").get_child_count():
		array_obj_interact.push_back([world_scene.get_node("NavigationRegion3D/All Interactable Spots").get_child(item).scene_file_path, \
		world_scene.get_node("NavigationRegion3D/All Interactable Spots").get_child(item).global_position, \
		world_scene.get_node("NavigationRegion3D/All Interactable Spots").get_child(item).rotation])
	new_config.set_value("Scene", "interactable", array_obj_interact)
	new_config.set_value("Player", "position", world_scene.get_node("Player").global_position)
	new_config.set_value("NPC", "count", world_scene.get_node("Walking_NPCs").get_child_count())
	var array_npc_position : Array
	for item in world_scene.get_node("Walking_NPCs").get_child_count():
		array_npc_position.push_back(world_scene.get_node("Walking_NPCs").get_child(item).global_position)
	new_config.set_value("NPC", "position", array_npc_position)
	new_config.save("user://SaveFile" + str(save_file_number) +".cfg")
	

func _load_function(world_scene: Node3D, save_file_number: int):
	current_savefile_loading = "user://SaveFile" + str(save_file_number) +".cfg"
	var loading = new_config.load(current_savefile_loading)
	if loading == OK:
		Globals.money = new_config.get_value("Globalvaribles", "money")
		Globals.spell_inventory_list = new_config.get_value("Globalvaribles", "spells")
		if new_config.get_value("Globalvaribles", "Aqua Vitae Timer") > 0:
			Globals.aqua_vitae_timer.start(new_config.get_value("Globalvaribles", "Aqua Vitae Timer"))
		Globals.aqua_fortis_active = new_config.get_value("Globalvaribles", "Aqua Fortis Active")
		if new_config.get_value("Globalvaribles", "Aqua Regia Timer") > 0:
			Globals.aqua_vitae_timer.start(new_config.get_value("Globalvaribles", "Aqua Regia Timer"))
		if new_config.get_value("Globalvaribles", "Aqua Philosophorum Timer") > 0:
			Globals.aqua_vitae_timer.start(new_config.get_value("Globalvaribles", "Aqua Philosophorum Timer"))
		world_scene.get_tree().change_scene_to_file(new_config.get_value("Scene", "World Scene"))
	else:
		return
	
