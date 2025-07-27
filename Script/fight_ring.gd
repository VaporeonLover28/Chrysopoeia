extends Node3D

@onready var homun_1_spawn: Marker3D = $homun1_spawn
@onready var homun_2_spawn: Marker3D = $homun2_spawn
@onready var ui: Control = $CanvasLayer/Fight_ring_UI
@onready var selec_desc: VBoxContainer = $CanvasLayer/Fight_ring_UI/Panel/HBoxContainer/Selec_Desc
@onready var selec_stats: HBoxContainer = $CanvasLayer/Fight_ring_UI/Panel/HBoxContainer/Selec_Desc/selec_stats
@onready var creatures: VBoxContainer = $CanvasLayer/Fight_ring_UI/Panel/HBoxContainer/Creatures

var selectable_creatures_array : Array
var slot_array : Array

func _ready() -> void:
	for slot in creatures.get_children():
		var creature_name : String
		var creature_dir_type : String
		var creature_atk_type : String
		var creature_price : int
		var creature_type_picker := randi_range(1, 4)
		match creature_type_picker:
			1:
				creature_dir_type = "Drunk"
				creature_name = "Drunk "
			2:
				creature_dir_type = "Righteous"
				creature_name = "Righteous "
			3:
				creature_dir_type = "Spinning"
				creature_name = "Spinning "
			4:
				creature_dir_type = "Focused"
				creature_name = "Focused "
		creature_type_picker = randi_range(1, 4)
		match creature_type_picker:
			1:
				creature_atk_type = "Cautious"
				creature_name += "Cautious "
			2:
				creature_atk_type = "Hard-Headed"
				creature_name += "Hard-Headed "
			3:
				creature_atk_type = "Purist"
				creature_name += "Purist "
			4:
				creature_atk_type = "Gambler"
				creature_name += "Gambler "
		creature_name += "Homunculus"
