extends InteractableObject; class_name SlotMachice

@onready var lever: Node3D = $lever
@onready var wheel_1: Node3D = $wheels/wheel1
@onready var wheel_2: Node3D = $wheels/wheel2
@onready var wheel_3: Node3D = $wheels/wheel3
@onready var wheel_4: Node3D = $wheels/wheel4
@onready var input_prompt: Node3D = $input_area/input_prompt
@onready var start: AudioStreamPlayer3D = $start
@onready var spin_sfx: AudioStreamPlayer3D = $spin

##Reward is [Name, Value, Odds]
##Odds is the minimum value the randi must be to choose this reward
##1-39 is mercury, 40-59 is sun, 60-74 is geocentrism, 75 to 84 is ra, 85 to 94 is trismegistus and 95 to 100 is ankh
var base_rewards : Array = [["Mercury", 10, 1], ["Sun", 20, 40], ["Geocentrism", 50, 60], 
["Ra", 75, 75], ["Trismegistus", 100, 85], ["Ankh", 0, 95]]
var fortune_rewards : Array = [["Mercury", 10, 1], ["Sun", 20, 20], ["Geocentrism", 50, 45], 
["Ra", 75, 60], ["Trismegistus", 100, 70], ["Ankh", 0, 90]]
var failed_fortune_rewards : Array = [["Mercury", 5, 1], ["Sun", 12, 40], ["Geocentrism", 35, 60], 
["Ra", 50, 75], ["Trismegistus", 80, 85], ["Ankh", 0, 95]]

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
var fortune := 0

##slot machice lol
##spin the wheel if it isn't spinning already
##clears the variables

func _ready() -> void:
	object_class = "SlotMachine"

func _interact_SlotMachine(object_ref):
	if !spinning:
		current_reward.clear()
		points = 0
		lever_pull()

func lever_pull():
	##if the player can afford to play
	if Globals.money - play_price >= 0:
		start.play()
		##take money
		Globals.money -= play_price
		##block the player from spinning again
		spinning = true
		##define the spin results
		if fortune == 0:
			spin_rewards(base_rewards)
		elif fortune == 1:
			spin_rewards(fortune_rewards)
		else:
			spin_rewards(failed_fortune_rewards)
		##tweening the lever to be pulled
		tween = create_tween()
		tween.set_trans(Tween.TRANS_BACK)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(lever, "rotation_degrees", Vector3(90, 0, 0), 0.66)
		tween.set_trans(Tween.TRANS_QUART)
		tween.tween_property(lever, "rotation_degrees", Vector3.ZERO, 0.66)
	##if cannot be afforded
		if play_price == 0:
			play_price = 30
	else:
		##just ignore
		pass

##defining the spin rewards
func spin_rewards(loot_table):
	spin_sfx.play()
	##pick a value between 1 and 100
	var random_value = randi_range(1, 100)
	##variable to stop multiple rewards from being chosen in one wheel
	var has_appended : bool = false
	##for each possible reward
	for i in loot_table:
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
				current_reward.append(loot_table[loot_table.find(i) - 1])
				#print(str(random_value) + " is smaller than " + str(i[2]) + ", appending " + rewards[rewards.find(i) - 1][0])
			##if already picked a reward
			else:
				#print("Already chose reward")
				pass
		##if it is an ankh
		else:
			##and it is able to be an ankh
			if random_value >= i[2]:
				##append the ankh
				current_reward.append(loot_table[loot_table.find(i)])
	
	##if not all rewards were picked
	if current_reward.size() < 4:
		##pick again
		spin_rewards(loot_table)
	##if they were, spin the wheel meshes
	else:
		#print(current_reward)
		##how many times the wheels do a full spin before settling on the reward picked
		var times = 5
		#print(times)
		spin(wheel_1, times, current_reward[0], loot_table)
		await get_tree().create_timer(0.75).timeout
		spin(wheel_2, times, current_reward[1], loot_table)
		await get_tree().create_timer(0.75).timeout
		spin(wheel_3, times, current_reward[2], loot_table)
		await get_tree().create_timer(0.75).timeout
		spin(wheel_4, times, current_reward[3], loot_table)
		times = 0

##spinning the wheel meshes
func spin(wheel, times_spun, reward, loot_table):
	wheels_spinning += 1
	##turns the reward from the array into an int
	var found_reward = loot_table.find(reward)
	##tweening the wheel
	tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	##cool math
	tween.tween_property(wheel, "rotation_degrees", Vector3(0, 90, times_spun * 360 + (360 - found_reward * 60)), times_spun)
	##await the wheel stopping
	await get_tree().create_timer(times_spun + 0.05).timeout
	##define that the wheel has stopped
	wheel_stopped(wheel, found_reward, loot_table)

func wheel_stopped(wheel, found_reward, loot_table):
	##reset the wheel's rotation
	wheel.rotation_degrees = Vector3(0, 90, (360 - found_reward * 60))
	wheels_spinning -= 1
	##if all the wheels are stopped
	if wheels_spinning == 0:
		##check for combos
		check_matching(loot_table)
	

##checking combos
func check_matching(loot_table):
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
				points += (loot_table[which_reward][1] + (how_many_match["Ankh"] * 100)) * how_many_match[type] * ankh_multiplier
			else:
				##gives points * multiplier
				points += loot_table[which_reward][1] * how_many_match[type] * ankh_multiplier
			#print("match of " + str(how_many_match[type]))
	##make the machine spinnable again
	spinning = false
	##give the earned money to the player
	if Globals.aqua_regia_timer.time_left > 0:
		points *= 2
	CoinEarned.moedas_01.play()
	Globals.money_lost = (Globals.money + points) - play_price
	Globals.money += points
	if Globals.aqua_fortis_active == true:
		play_price = 0
		lever_pull()
		Globals.aqua_fortis_active = false

func spell_cast(spell : String):
	if Globals.check_spell_available(spell):
		Globals.cooldown_spell(spell)
		var spell_worked = randi_range(1, 4)
		if spell_worked == 4:
			fortune = -1
		else:
			fortune = 1

func input_disappear():
	Globals.fortuna_target = null
	input_prompt.visible = false

func _on_input_area_body_entered(body: Node3D) -> void:
	if Globals.check_spell_available("Wheel of Fortune") and body.name == "Player":
		Globals.fortuna_target = self
		input_prompt.visible = true

func _on_input_area_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		Globals.fortuna_target = null
		input_prompt.visible = false
