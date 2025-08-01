extends CharacterBody3D

@onready var change_dir: Timer = $change_dir
@onready var attack: Timer = $attack
@onready var bounty_label: Label3D = $bounty
@onready var hp_label: Label3D = $hp
@onready var yourbet: Label3D = $yourbet
@onready var sprite: AnimatedSprite3D = $sprite_placeholder

var enemy : CharacterBody3D
var enemy_in_atk_area := false

var bounty : int = 0
@export var health := 100.0
@export var damage := 10.0

var dead := false
var chained := false

##Standart, Random movement, Biased side-to-side, Biased forward-back, Only forward-back
@export_enum("Simple", "Drunk", "Crableg", "Jabber", "Focused") var dir_type : String
##Meatier weak, Thinner strong, Middle ground, Random, Meatier very weak fast-attack
@export_enum("Cautious", "Hard-Headed", "Purist", "Gambler", "Tickler") var atk_type : String

var turn_to_chance := {"north": 0, "northeast": 0, "east": 0, \
"southeast": 0, "south": 0, "southwest": 0, "west": 0, "northwest": 0}

var current_direction := Vector3(0, 0, 0)
var current_dir_num := 0
var dirs_array := ["north", "northeast", "east", "southeast", "south", "southwest", "west", "northwest"]
var dirs_dictionary := {
	"north": Vector3(0, 0, -1) * transform.basis,
	"northeast": Vector3(1, 0, -1).normalized() * transform.basis,
	"east": Vector3(1, 0, 0) * transform.basis,
	"southeast": Vector3(1, 0, 1).normalized() * transform.basis,
	"south": Vector3(0, 0, 1) * transform.basis,
	"southwest": Vector3(-1, 0, 1).normalized() * transform.basis,
	"west": Vector3(-1, 0, 0) * transform.basis,
	"northwest": Vector3(-1, 0, -1).normalized() * transform.basis
}

func match_stats():
	match dir_type:
		"Simple":
			turn_to_chance["north"] = 12.5
			turn_to_chance["northeast"] = 14.3
			turn_to_chance["east"] = 16.7
			turn_to_chance["southeast"] = 20
			turn_to_chance["south"] = 25
			turn_to_chance["southwest"] = 33
			turn_to_chance["west"] = 50
			turn_to_chance["northwest"] = 100
		"Drunk":
			turn_to_chance["north"] = 12.5 + randf_range(-5, 5)
			turn_to_chance["northeast"] = 14.3 + randf_range(-5, 5)
			turn_to_chance["east"] = 16.7 + randf_range(-5, 5)
			turn_to_chance["southeast"] = 20 + randf_range(-5, 5)
			turn_to_chance["south"] = 25 + randf_range(-5, 5)
			turn_to_chance["southwest"] = 33 + randf_range(-5, 5)
			turn_to_chance["west"] = 50 + randf_range(-5, 5)
			turn_to_chance["northwest"] = 100
		"Crableg":
			turn_to_chance["east"] = 25
			turn_to_chance["west"] = 33.3
			turn_to_chance["north"] = 16.7
			turn_to_chance["southeast"] = 20
			turn_to_chance["south"] = 25
			turn_to_chance["southwest"] = 33.3
			turn_to_chance["northeast"] = 50
			turn_to_chance["northwest"] = 100
		"Jabber":
			turn_to_chance["north"] = 25
			turn_to_chance["south"] = 33.3
			turn_to_chance["east"] = 16.7
			turn_to_chance["southeast"] = 20
			turn_to_chance["west"] = 25
			turn_to_chance["southwest"] = 33.3
			turn_to_chance["northeast"] = 50
			turn_to_chance["northwest"] = 100
		"Focused":
			turn_to_chance["northeast"] = -1
			turn_to_chance["east"] = -1
			turn_to_chance["southeast"] =-1
			turn_to_chance["southwest"] = -1
			turn_to_chance["west"] = -1
			turn_to_chance["northwest"] = -1
			turn_to_chance["north"] = 50
			turn_to_chance["south"] = 100
	match atk_type:
		"Cautious":
			health = 125.0
			damage = 7.5
		"Hard-Headed":
			health = 90.0
			damage = 12.5
		"Purist":
			health = 100
			damage = 10
		"Gambler":
			health = 110
			damage = 11
		"Tickler":
			health = 100
			damage = 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bounty_label.text = "$" + str(bounty)
	hp_label.text = "HP: " + str(health)
	look_at(enemy.global_position)
	rotation_degrees.x = 0
	rotation_degrees.z = 0
	if !chained:
		position += current_direction * transform.basis * delta
	else:
		sprite.play("hurt")
	if rotation_degrees.y >= 180 or rotation_degrees.y <= 0:
		if !sprite.flip_h:
			sprite.flip_h = true
	elif sprite.flip_h:
			sprite.flip_h = false
	move_and_slide()

func attack_enemy():
	if enemy_in_atk_area:
		enemy.take_dmg(damage)

func take_dmg(dmg):
	get_parent().inactivity.start()
	health -= dmg
	if health > 0:
		sprite.play("hurt")
		await get_tree().create_timer(0.5).timeout
		sprite.play("default")
	else:
		sprite.play("hurt")
		dead = true

func change_direction():
	match dir_type:
		"Simple":
			pick_dir()
			change_dir.start(randf_range(1, 2))
		"Drunk":
			pick_dir()
			change_dir.start(randf_range(1, 2))
		"Crableg":
			pick_dir()
			change_dir.start(randf_range(1, 1.6))
		"Jabber":
			pick_dir()
			change_dir.start(randf_range(1, 2))
		"Focused":
			pick_dir()
			change_dir.start(randf_range(1.4, 2))

func pick_dir():
	var dir_picker := randf_range(0, 100)
	if dir_picker <= turn_to_chance[dirs_array[current_dir_num]]:
		current_direction = dirs_dictionary[dirs_array[current_dir_num]]
	else:
		current_dir_num += 1
		pick_dir()

func _on_change_dir_timeout() -> void:
	current_dir_num = 0
	change_direction()

func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.name == enemy.name:
		enemy_in_atk_area = true

func _on_hitbox_body_exited(body: Node3D) -> void:
	if body.name == enemy.name:
		enemy_in_atk_area = false

func _on_attack_timeout() -> void:
	attack_enemy()
	match atk_type:
		"Cautious":
			random_atk_cd(1.25)
		"Hard-Headed":
			random_atk_cd(1.5)
		"Purist":
			random_atk_cd(1)
		"Gambler":
			random_atk_cd(randf_range(0.75, 1.5))
		"Tickler":
			random_atk_cd(0.3)

func random_atk_cd(baseatkcd):
	attack.start(randf_range(baseatkcd / 1.25, baseatkcd * 1.25))

func mars():
	print("mars")
	damage * 1.25

func failed_mars():
	print("failed mars")
	health += 20
	damage /= 1.5
