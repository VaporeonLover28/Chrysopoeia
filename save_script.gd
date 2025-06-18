var current_savefile_loading: String
var new_config : ConfigFile

func _init() -> void:
	new_config = ConfigFile.new()

func _save_function(world_scene: Node3D, save_file_number: int):
	new_config.set_value("Scene", "World Scene", world_scene.filename)
	new_config.set_value("Scene", "interactable object count", world_scene.get_node("NavigationRegion3D/CSGCombiner3D/All Interactable Spots").get_child_count())
	var array_obj_interact_position : Array
	for item in world_scene.get_node("NavigationRegion3D/CSGCombiner3D/All Interactable Spots").get_child_count():
		array_obj_interact_position.push_back(world_scene.get_node("NavigationRegion3D/CSGCombiner3D/All Interactable Spots").get_child(item).global_position)
	new_config.set_value("Scene", "interactable object position", array_obj_interact_position)
	new_config.set_value("Globalvaribles", "money", Globals.money)
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
		world_scene.get_tree().change_scene_to_file(new_config.get_value("Scene", "World Scene"))
	else:
		return
	
