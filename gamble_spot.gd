extends InteractableObject; class_name GambleSpot


@onready var camera: Camera3D = $camera
@onready var marker: Marker3D = $marker
@onready var sit_positions: Node3D = $"Sit positions"
@onready var ChairPositionTaken = preload("res://chair_position.gd")
var is_pulling : bool
var chosen_camera_position:Marker3D

func _ready() -> void:
	for item in sit_positions.get_child_count():
		sit_positions.get_child(item).set_script(ChairPositionTaken)
# Called when the node enters the scene tree for the first time.
func _gamble_interact(object_ref):
	if object_ref.name == "Player":
		Globals.player_interacting = true
		#checks for marker with the smallest postion distance to player
		_take_spot(object_ref)
	else:
		_take_spot(object_ref)

func _camera_transition(object) -> void:
	object.camera.current = false
	camera.global_position = object.camera.global_position
	camera.rotation = object.camera.rotation
	camera.current = true

func _process(delta: float) -> void:
	if is_pulling == true:
		_pull_camera()

func _pull_camera():
	camera.global_position = lerp(camera.global_position, chosen_camera_position.global_position, get_process_delta_time() * 3)
	camera.look_at($CSGBox3D.global_position)

func _take_spot(object):
	chosen_camera_position = null
	var smallest_distance : Vector3
	for item in sit_positions.get_child_count():
		if smallest_distance > object.global_position - sit_positions.get_child(item).global_position:
			chosen_camera_position = sit_positions.get_child(item)
			smallest_distance = sit_positions.get_child(item).global_position
			chosen_camera_position
			is_pulling = true
		else:
			print("não escolhido")
	_camera_transition(object)
func _leave_spot():
	pass
func _start_game():
	pass
