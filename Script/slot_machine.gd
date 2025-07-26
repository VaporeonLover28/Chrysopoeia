extends Node3D

@onready var lever: Node3D = $lever
@onready var wheel_1: Node3D = $wheels/wheel1
@onready var wheel_2: Node3D = $wheels/wheel2
@onready var wheel_3: Node3D = $wheels/wheel3
@onready var wheel_4: Node3D = $wheels/wheel4

##Reward is [Name, Value, Odds]
##Odds is the minimum value the randi must be to choose this reward
##1-39 is mercury, 40-59 is sun, 60-74 is geocentrism, 75 to 84 is ra, 85 to 94 is trismegistus and 95 to 100 is ankh
var rewards : Array = [["Mercury", 10, 1], ["Sun", 20, 40], ["Geocentrism", 50, 60], 
["Ra", 75, 75], ["Trismegistus", 100, 85], ["Ankh", 0, 95]]
#var rewards : Array = [["Mercury", 10, 1], ["Sun", 20, 1], ["Geocentrism", 50, 1], 
#["Ra", 75, 1], ["Trismegistus", 100, 1], ["Ankh", 0, 1]]
var tween : Tween

var money : int = 150
var play_price : int = 30
var current_reward : Array
var points : int = 0
var wheels_spinning : int = 0
var spinning : bool = false

func _process(delta: float) -> void:
	$Camera3D/CanvasLayer/Label.text = "Money: " + str(money)
	if Input.is_action_just_pressed("space") and !spinning:
		current_reward.clear()
		points = 0
		lever_pull()

func lever_pull():
	spinning = true
	if money - play_price >= 0:
		money -= play_price
		spin_rewards()
		tween = create_tween()
		tween.set_trans(Tween.TRANS_BACK)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(lever, "rotation_degrees", Vector3(90, 0, 0), 0.66)
		tween.set_trans(Tween.TRANS_QUART)
		tween.tween_property(lever, "rotation_degrees", Vector3.ZERO, 0.66)
	else:
		get_tree().quit()

func spin_rewards():
	var random_value = randi_range(1, 100)
	var has_appended : bool = false
	for i in rewards:
		if i[0] != "Ankh":
			if random_value >= i[2]:
				#print(str(random_value) + " is bigger or equal to " + str(i[2]) + ", checking other rewards")
				pass
			elif !has_appended:
				has_appended = true
				current_reward.append(rewards[rewards.find(i) - 1])
				#print(str(random_value) + " is smaller than " + str(i[2]) + ", appending " + rewards[rewards.find(i) - 1][0])
			else:
				#print("Already chose reward")
				pass
		else:
			if random_value >= i[2]:
				current_reward.append(rewards[rewards.find(i)])
	if current_reward.size() < 4:
		spin_rewards()
	else:
		print(current_reward)
		var times = randi_range(5, 7)
		spin(wheel_1, times, current_reward[0])
		await get_tree().create_timer(0.75).timeout
		spin(wheel_2, times, current_reward[1])
		await get_tree().create_timer(0.75).timeout
		spin(wheel_3, times, current_reward[2])
		await get_tree().create_timer(0.75).timeout
		spin(wheel_4, times, current_reward[3])

func spin(wheel, times_spun, reward):
	wheels_spinning += 1
	var found_reward = rewards.find(reward)
	tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(wheel, "rotation_degrees", Vector3(0, 90, times_spun * 360 + (360 - found_reward * 60)), times_spun + found_reward * 0.33)
	await get_tree().create_timer(times_spun + found_reward * 0.33).timeout
	wheel_stopped(wheel, found_reward)

func wheel_stopped(wheel, found_reward):
	wheel.rotation_degrees = Vector3(0, 90, (360 - found_reward * 60))
	wheels_spinning -= 1
	if wheels_spinning == 0:
		check_matching()

func check_matching():
	var how_many_match := {"Mercury": 0, "Sun": 0, "Geocentrism": 0, "Ra": 0, "Trismegistus": 0, "Ankh": 0}
	for item in current_reward:
		how_many_match[item[0]] += 1
	
	var which_reward = -1
	var has_ankh : bool = how_many_match["Ankh"] > 0
	var ankh_multiplier : int = 2 * how_many_match["Ankh"] if has_ankh else 1
	for type in how_many_match:
		which_reward += 1
		if how_many_match[type] >= 2:
			if how_many_match["Ankh"] > 1:
				points += (rewards[which_reward][1] + (how_many_match["Ankh"] * 100)) * how_many_match[type] * ankh_multiplier
			else:
				points += rewards[which_reward][1] * how_many_match[type] * ankh_multiplier
			#print("match of " + str(how_many_match[type]))
	spinning = false
	money += points
		#else:
			#print("not a match")
