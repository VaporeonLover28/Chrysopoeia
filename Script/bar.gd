extends InteractableObject

@onready var world: Node3D = $"../../.."
@onready var camera: Camera3D = $camera
@onready var sit_positions: Node = $"Sit positions"
@onready var MAGO_BAR = preload("res://Scenes/mago_bar.tscn")

signal bought_bar

func _ready() -> void:
	if Globals.bar_unlock == true:
		var mage_instance = MAGO_BAR.instantiate()
		self.add_child(mage_instance)
		mage_instance.position = Vector3(1.5, -0.5 , -1.1)
		
	
func _interact_Bar(object_ref):
	if sit_positions._ASAT() != true:
		sit_positions._sit_character(object_ref)
		if Globals.bar_unlock == true:
			if object_ref.name == "Player":
				world.get_node("Bar UI").get_child(0).show_bar_ui(self)
			else:
				match randi_range(1, 4):
					1:
						Globals.money += 25
					2:
						Globals.money += 80
					3:
						Globals.money += 120
					4:
						Globals.money += 100

func _cancel_interact_Bar(object_ref):
	sit_positions._stand_character_up(object_ref)


func _on_bought_bar() -> void:
	var mage_instance = MAGO_BAR.instantiate()
	self.add_child(mage_instance)
	mage_instance.position = Vector3(1.5, -0.5 , -1.1)
