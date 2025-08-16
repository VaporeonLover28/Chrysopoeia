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
	##Makes each direction AI have a better chance of going some direction
	match dir_type:
		"Simple":
			##In simple AI, every direction is statistically equally likely
			##Roll a number, if it's lesser than 12.5, turn north
			##12.5 is 1/8th, or 1/directions remaining
			turn_to_chance["north"] = 12.5
			##If not, roll a number, if lesser than 14.3, turn northeast
			##14.3 is 1/7th
			turn_to_chance["northeast"] = 14.3
			##1/6th
			turn_to_chance["east"] = 16.7
			turn_to_chance["southeast"] = 20
			turn_to_chance["south"] = 25
			turn_to_chance["southwest"] = 33
			turn_to_chance["west"] = 50
			##By this point, all other options were not chosen
			turn_to_chance["northwest"] = 100
		"Drunk":
			##Slight change in each chance
			turn_to_chance["north"] = 12.5 + randf_range(-5, 5)
			turn_to_chance["northeast"] = 14.3 + randf_range(-5, 5)
			turn_to_chance["east"] = 16.7 + randf_range(-5, 5)
			turn_to_chance["southeast"] = 20 + randf_range(-5, 5)
			turn_to_chance["south"] = 25 + randf_range(-5, 5)
			turn_to_chance["southwest"] = 33 + randf_range(-5, 5)
			turn_to_chance["west"] = 50 + randf_range(-5, 5)
			turn_to_chance["northwest"] = 100
		"Crableg":
			##More biased to go east or west (Statistical 50% for any of them, 50% for others)
			turn_to_chance["east"] = 25
			turn_to_chance["west"] = 33.3
			turn_to_chance["north"] = 16.7
			turn_to_chance["southeast"] = 20
			turn_to_chance["south"] = 25
			turn_to_chance["southwest"] = 33.3
			turn_to_chance["northeast"] = 50
			turn_to_chance["northwest"] = 100
		"Jabber":
			##More biased to go north or south
			turn_to_chance["north"] = 25
			turn_to_chance["south"] = 33.3
			turn_to_chance["east"] = 16.7
			turn_to_chance["southeast"] = 20
			turn_to_chance["west"] = 25
			turn_to_chance["southwest"] = 33.3
			turn_to_chance["northeast"] = 50
			turn_to_chance["northwest"] = 100
		"Focused":
			##Only north or south
			turn_to_chance["northeast"] = -1
			turn_to_chance["east"] = -1
			turn_to_chance["southeast"] =-1
			turn_to_chance["southwest"] = -1
			turn_to_chance["west"] = -1
			turn_to_chance["northwest"] = -1
			turn_to_chance["north"] = 50
			turn_to_chance["south"] = 100
	match atk_type:
		##Matches stats for attack AI
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

func _process(delta: float) -> void:
	bounty_label.text = str(bounty) + " Gold"
	hp_label.text = "HP: " + str(health)
	look_at(enemy.global_position)
	rotation_degrees.x = 0
	rotation_degrees.z = 0
	
	##Homunculus moves if it isn't chained
	if !chained and !get_parent().match_ended:
		position += current_direction * transform.basis * delta
	elif chained:
		sprite.play("hurt")
	else:
		if dead:
			global_position.y = 0.6
			sprite.play("hurt")
			sprite.billboard = BaseMaterial3D.BILLBOARD_DISABLED
			rotation_degrees.x = 90
	
	if rotation_degrees.y >= 180 or rotation_degrees.y <= 0:
		if !sprite.flip_h:
			sprite.flip_h = true
	elif sprite.flip_h:
			sprite.flip_h = false
	
	move_and_slide()

func attack_enemy():
	if enemy_in_atk_area:
		if randf() > 0.5:
			sprite.play("hit")
		else:
			sprite.play("hit2")
		enemy.take_dmg(damage)
		
func take_dmg(dmg):
	##Starts the inactivity timer to stop the chain
	get_parent().inactivity.start()
	
	health -= dmg
	
	if health > 0:
		sprite.play("hurt")
		await get_tree().create_timer(1).timeout
		sprite.play("default")
	else:
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
	##If the random number is lesser than the chance required to turn to this direction
	if dir_picker <= turn_to_chance[dirs_array[current_dir_num]]:
		##Change direction to the vector3 for that direction
		current_direction = dirs_dictionary[dirs_array[current_dir_num]]
	else:
		##Try again for next direction
		current_dir_num += 1
		pick_dir()

func _on_change_dir_timeout() -> void:
	##Reset the current dir number
	current_dir_num = 0
	change_direction()

func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.name == enemy.name:
		enemy_in_atk_area = true

func _on_hitbox_body_exited(body: Node3D) -> void:
	if body.name == enemy.name:
		enemy_in_atk_area = false

##Attacks with a slighty random cooldown based on atk AI
func _on_attack_timeout() -> void:
	if !get_parent().match_ended:
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
				random_atk_cd(0.05)

##Randomize the cd
func random_atk_cd(baseatkcd):
	if get_parent().match_started:
		attack.start(randf_range(baseatkcd / 1.25, baseatkcd * 1.25))

func mars():
	print("mars")
	damage * 1.25

func failed_mars():
	print("failed mars")
	health += 20
	damage /= 2
