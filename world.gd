extends Node3D

@onready

func _init() -> void:
	var new_config = ConfigFile.new()
	if SaveScript.current_savefile_loading != null:
		var loading = new_config.load(SaveScript.current_savefile_loading)
		if loading == OK:
			new_config.set_value("Globalvaribles", "money", Globals.money)
			new_config.get_value("Player", "position")
			for item in new_config.get_value("NPC", "count"):
				
		else:
			return
