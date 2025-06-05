extends Node3D; class_name InteractableObject


@export_category("Object basics")
@export var object_class : String


func _interact(pass_interact_parameter : Array = []):

	match pass_interact_parameter.size():
		0:
			call("_interact_" + object_class)
		1:
			call("_interact_" + object_class, pass_interact_parameter[0])
		2:
			call("_interact_" + object_class, pass_interact_parameter[0], \
			pass_interact_parameter[1])
		3:
			call("_interact_" + object_class, \
			 pass_interact_parameter[0], \
			 pass_interact_parameter[1], pass_interact_parameter[2])
		4:
			call("_interact_" +object_class, \
			 pass_interact_parameter[0], \
			 pass_interact_parameter[1], pass_interact_parameter[2], \
			pass_interact_parameter[3])
