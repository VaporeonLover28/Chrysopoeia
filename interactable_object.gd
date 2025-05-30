extends Node3D; class_name InteractableObject

@onready var camera: Camera3D = $camera
@onready var marker: Marker3D = $marker

var is_pulling = false
var is_opening = false

func _interact(player_ref):
	if is_in_group("Camera Pullers"):
		is_pulling = true
		_camera_transition(player_ref)
	elif is_in_group("Doors"):
		is_opening = true
		_open()

func _camera_transition(player) -> void:
	player.camera.current = false
	camera.global_position = player.camera.global_position
	camera.rotation = player.camera.rotation
	camera.current = true

func _process(delta: float) -> void:
	if is_in_group("Camera Pullers") and is_pulling == true:
		_pull_camera()
	elif is_in_group("Doors") and is_opening == true:
		_open()

func _pull_camera():
	camera.global_position = lerp(camera.global_position, marker.global_position, get_process_delta_time() * 3)
	camera.look_at($CSGBox3D.global_position)

func _open():
	print("nhheeeeeeeeeeeeec")
