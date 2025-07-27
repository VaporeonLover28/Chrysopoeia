extends InteractableObject; class_name SlotMachice

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

##creating a tween
var tween : Tween

##how much it costs to play
var play_price : int = 30
##array containing the results
var current_reward : Array
##what is going to be given at the end of the spin
var points : int = 0
##how many wheels are spinning
var wheels_spinning : int = 0
##if any wheels are spinning
var spinning : bool = false

##slot machice lol
##spin the wheel if it isn't spinning already
##clears the variables
func _interact_SlotMachice(object_ref):
	if !spinning:
		current_reward.clear()
		points = 0
		lever_pull()

func lever_pull():
	##block the player from spinning again
	spinning = true
	##if the player can afford to play
	if Globals.money - play_price >= 0:
		##take money
		Globals.money -= play_price
		##define the spin results
		spin_rewards()
		##tweening the lever to be pulled
		tween = create_tween()
		tween.set_trans(Tween.TRANS_BACK)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(lever, "rotation_degrees", Vector3(90, 0, 0), 0.66)
		tween.set_trans(Tween.TRANS_QUART)
		tween.tween_property(lever, "rotation_degrees", Vector3.ZERO, 0.66)
	##if cannot be afforded
	else:
		##just ignore
		pass

##defining the spin rewards
func spin_rewards():
	##pick a value between 1 and 100
	var random_value = randi_range(1, 100)
	##variable to stop multiple rewards from being chosen in one wheel
	var has_appended : bool = false
	##for each possible reward
	for i in rewards:
		##if it isn't an ankh (no next reward to check)
		if i[0] != "Ankh":
			##if the random value is above the minimum number to be the reward
			if random_value >= i[2]:
				#print(str(random_value) + " is bigger or equal to " + str(i[2]) + ", checking other rewards")
				##keep checking the others
				pass
			##if it is not the minimum number to be this reward
			##and it hasn't already picked a reward
			elif !has_appended:
				##pick the reward
				has_appended = true
				##appends the last reward (couldn't afford the one currently checked, but could the last)
				current_reward.append(rewards[rewards.find(i) - 1])
				#print(str(random_value) + " is smaller than " + str(i[2]) + ", appending " + rewards[rewards.find(i) - 1][0])
			##if already picked a reward
			else:
				#print("Already chose reward")
				pass
		##if it is an ankh
		else:
			##and it is able to be an ankh
			if random_value >= i[2]:
				print(random_value)
				##append the ankh
				current_reward.append(rewards[rewards.find(i)])
	
	##if not all rewards were picked
	if current_reward.size() < 4:
		##pick again
		spin_rewards()
	##if they were, spin the wheel meshes
	else:
		#print(current_reward)
		##how many times the wheels do a full spin before settling on the reward picked
		var times = randi_range(5, 7)
		#print(times)
		spin(wheel_1, times, current_reward[0])
		await get_tree().create_timer(0.75).timeout
		spin(wheel_2, times, current_reward[1])
		await get_tree().create_timer(0.75).timeout
		spin(wheel_3, times, current_reward[2])
		await get_tree().create_timer(0.75).timeout
		spin(wheel_4, times, current_reward[3])
		times = 0

##spinning the wheel meshes
func spin(wheel, times_spun, reward):
	wheels_spinning += 1
	##turns the reward from the array into an int
	var found_reward = rewards.find(reward)
	##tweening the wheel
	tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	##cool math
	tween.tween_property(wheel, "rotation_degrees", Vector3(0, 90, times_spun * 360 + (360 - found_reward * 60)), times_spun)
	##await the wheel stopping
	await get_tree().create_timer(times_spun).timeout
	##define that the wheel has stopped
	wheel_stopped(wheel, found_reward)

func wheel_stopped(wheel, found_reward):
	##reset the wheel's rotation
	wheel.rotation_degrees = Vector3(0, 90, (360 - found_reward * 60))
	wheels_spinning -= 1
	##if all the wheels are stopped
	if wheels_spinning == 0:
		##check for combos
		check_matching()

##checking combos
func check_matching():
	##how many of each symbol were picked
	var how_many_match : Dictionary = {"Mercury": 0, "Sun": 0, "Geocentrism": 0, "Ra": 0, "Trismegistus": 0, "Ankh": 0}
	##adding them to the dictionary
	for item in current_reward:
		how_many_match[item[0]] += 1
	
	##int version of the reward for array positioning
	var which_reward = -1
	##if ankhs were picked (you can do booleans like this lol)
	var has_ankh : bool = how_many_match["Ankh"] > 0
	##how much each symbol is multiplied by (you can do ints like this lol)
	var ankh_multiplier : int = 2 * how_many_match["Ankh"] if has_ankh else 1
	##for each reward type (key in dict)
	for type in how_many_match:
		##increase the int
		which_reward += 1
		##if there is a combo of 2 or more
		if how_many_match[type] >= 2:
			##if an ankh has a combo
			if how_many_match["Ankh"] > 1:
				##gives (points + combo ankh points) * multiplier 
				points += (rewards[which_reward][1] + (how_many_match["Ankh"] * 100)) * how_many_match[type] * ankh_multiplier
			else:
				##gives points * multiplier
				points += rewards[which_reward][1] * how_many_match[type] * ankh_multiplier
			#print("match of " + str(how_many_match[type]))
	##make the machine spinnable again
	spinning = false
	##give the earned money to the player
	Globals.money += points
		#else:
			#print("not a match")
