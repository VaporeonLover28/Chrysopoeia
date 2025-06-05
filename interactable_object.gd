extends Node3D; class_name InteractableObject


@export_category("Object basics")
@export var pass_interact_func : String
@export var need_object_ref : bool
@export var pass_interact_parameter : Array

func _interact(object_ref):
	if need_object_ref == true:
		match pass_interact_parameter.size():
			0:
				call(pass_interact_func, object_ref)
			1:
				call(pass_interact_func, object_ref, pass_interact_parameter[0])
			2:
				call(pass_interact_func, object_ref,pass_interact_parameter[0], \
				pass_interact_parameter[1])
			3:
				call(pass_interact_func, object_ref, \
				 pass_interact_parameter[0], \
				 pass_interact_parameter[1], pass_interact_parameter[2])
	else: 
		match pass_interact_parameter.size():
			0:
				call(pass_interact_func)
			1:
				call(pass_interact_func, pass_interact_parameter[0])
			2:
				call(pass_interact_func, pass_interact_parameter[0], \
				pass_interact_parameter[1])
			3:
				call(pass_interact_func, \
				 pass_interact_parameter[0], \
				 pass_interact_parameter[1], pass_interact_parameter[2])
	
