extends CharacterBody3D

@onready var change_dir: Timer = $change_dir

@export var speed = 0.1
@export_enum("Drunk", "Righteous", "Spinning", "Focused") var dir_type : String
@export_enum("Cautious", "Hard-Headed", "Purist", "Gambler") var atk_type : String

var current_direction := Vector3(0, 0, 0)
var current_dir_num := 0
var dirs_array := ["still", "north", "northeast", "east", "southeast", "south", "southwest", "west", "northwest"]
var dirs_dictionary := {
	"still": Vector3(0, 0, 0),
	"north": Vector3(0, 0, -1),
	"northeast": Vector3(1, 0, -1).normalized(),
	"east": Vector3(1, 0, 0),
	"southeast": Vector3(1, 0, 1).normalized(),
	"south": Vector3(0, 0, 1),
	"southwest": Vector3(-1, 0, 1).normalized(),
	"west": Vector3(-1, 0, 0),
	"northwest": Vector3(-1, 0, -1).normalized()
}

func _ready() -> void:
	var random_type := randi_range(1, 4)
	match random_type:
		1:
			dir_type = "Drunk"
			name = "Drunk "
		2:
			dir_type = "Righteous"
			name = "Righteous "
		3:
			dir_type = "Spinning"
			name = "Spinning "
		4:
			dir_type = "Focused"
			name = "Focused "
	random_type = randi_range(1, 4)
	match random_type:
		1:
			atk_type = "Cautious"
			name += "Cautious "
		2:
			atk_type = "Hard-Headed"
			name += "Hard-Headed "
		3:
			atk_type = "Purist"
			name += "Purist "
		4:
			atk_type = "Gambler"
			name += "Gambler "
	name += "Homunculus"
	print(name)
	change_dir.start(randf_range(0.25, 0.40))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(current_dir_num, current_direction)
	if velocity.x < current_direction.x:
		velocity.x += speed
	elif velocity.x > current_direction.x:
		velocity.x = current_direction.x
	if velocity.y < current_direction.y:
		velocity.y += speed
	elif velocity.y > current_direction.y:
		velocity.y = current_direction.y
	if velocity.z < current_direction.z:
		velocity.z += speed
	elif velocity.z > current_direction.z:
		velocity.z = current_direction.z
	move_and_slide()

func change_direction():
	match dir_type:
		"Drunk":
			var will_change = randi_range(1, 3)
			if will_change == 1:
				var which_dir = randi_range(0, 8)
				current_direction = dirs_dictionary[dirs_array[which_dir]]
		"Righteous":
			if current_dir_num + 1 != 9:
				current_direction = dirs_dictionary[dirs_array[current_dir_num + 1]]
				current_dir_num += 1
			else:
				current_direction = dirs_dictionary[dirs_array[0]]
				current_dir_num = 0
		"Spinning":
			if current_dir_num - 1 != -1:
				current_direction = dirs_dictionary[dirs_array[current_dir_num - 1]]
				current_dir_num -= 1
			else:
				current_direction = dirs_dictionary[dirs_array[8]]
				current_dir_num = 8
		"Focused":
			var will_change = randi_range(1, 3)
			if will_change == 1:
				var which_dir = randi_range(0, 1)
				match which_dir:
					0:
						current_direction = transform.basis.z * -1
					1:
						current_direction = transform.basis.z

func _on_change_dir_timeout() -> void:
	change_dir.start(randf_range(0.25, 0.40))
	change_direction()
