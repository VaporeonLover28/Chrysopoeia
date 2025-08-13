extends Node

var current_savefile_loading: String
var new_config : ConfigFile

func _init() -> void:
	new_config = ConfigFile.new()

func _save_function(world_scene: Node3D, save_file_number: int):
	new_config.set_value("Globalvaribles", "money", Globals.money)
	new_config.set_value("Globalvaribles", "spells", Globals.spell_inventory_list)
	new_config.set_value("Globalvaribles", "item_list_level", PurchasableItemList.item_list_level)
	new_config.set_value("Globalvaribles", "ring_unlock", Globals.ring_unlock)
	new_config.set_value("Globalvaribles", "Aqua Vitae Timer", Globals.aqua_vitae_timer.time_left)
	new_config.set_value("Globalvaribles", "Aqua Fortis Active", Globals.aqua_fortis_active)
	new_config.set_value("Globalvaribles", "Aqua Regia Timer", Globals.aqua_regia_timer.time_left)
	new_config.set_value("Globalvaribles", "Aqua Philosophorum Timer", Globals.aqua_philosophorum_timer.time_left)
	new_config.set_value("Scene", "World Scene", world_scene.scene_file_path)
	new_config.set_value("Scene", "interactable object count",\
	world_scene.get_node("NavigationRegion3D/All Interactable Spots").get_child_count())
	var array_obj_interact : Array
	for item in world_scene.get_node("NavigationRegion3D/All Interactable Spots").get_children():
		array_obj_interact.push_back([item.scene_file_path, item.global_position, item.rotation])
	new_config.set_value("Scene", "interactable", array_obj_interact)
	new_config.set_value("Player", "position", world_scene.get_node("Player").global_position)
	var save_npcs_array: Array[Array]
	for item in world_scene.get_node("Walking_NPCs").get_children():
		var save_npcs_info : Array
		save_npcs_info.push_back(item.scene_file_path)
		save_npcs_info.push_back(item.global_position)
		save_npcs_array.push_back(save_npcs_info)
	new_config.set_value("NPC", "info", save_npcs_array)
	new_config.save("user://SaveFile" + str(save_file_number) +".cfg")
	

func _load_function(save_file_number: int):
	current_savefile_loading = "user://SaveFile" + str(save_file_number) +".cfg"
	var loading = new_config.load(current_savefile_loading)
	if loading == OK:
		Globals.money = new_config.get_value("Globalvaribles", "money")
		Globals.spell_inventory_list = new_config.get_value("Globalvaribles", "spells")
		PurchasableItemList.item_list_level = new_config.get_value("Globalvaribles", "item_list_level")
		Globals.ring_unlock = new_config.get_value("Globalvaribles", "ring_unlock")
		if new_config.get_value("Globalvaribles", "Aqua Vitae Timer") > 0:
			Globals.aqua_vitae_timer.start(new_config.get_value("Globalvaribles", "Aqua Vitae Timer"))
		Globals.aqua_fortis_active = new_config.get_value("Globalvaribles", "Aqua Fortis Active")
		if new_config.get_value("Globalvaribles", "Aqua Regia Timer") > 0:
			Globals.aqua_vitae_timer.start(new_config.get_value("Globalvaribles", "Aqua Regia Timer"))
		if new_config.get_value("Globalvaribles", "Aqua Philosophorum Timer") > 0:
			Globals.aqua_vitae_timer.start(new_config.get_value("Globalvaribles", "Aqua Philosophorum Timer"))
		get_tree().change_scene_to_file(new_config.get_value("Scene", "World Scene"))
	else:
		return
	
