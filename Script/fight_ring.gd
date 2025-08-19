extends Node3D

@onready var homun_1_spawn: Marker3D = $homun1_spawn
@onready var homun_2_spawn: Marker3D = $homun2_spawn
@onready var ui: Control = $Fight_ring_UI/UI
@onready var selec_desc: VBoxContainer = $Fight_ring_UI/UI/Panel/HBoxContainer/Selec_Desc
@onready var selec_stats: HBoxContainer = $Fight_ring_UI/UI/Panel/HBoxContainer/Selec_Desc/selec_stats
@onready var creatures: VBoxContainer = $Fight_ring_UI/UI/Panel/HBoxContainer/Creatures
@onready var homunculus = preload("res://Scenes/homunculus.tscn")
@onready var chainpos: Node3D = $chainpos
@onready var chain: Sprite3D = $chain
@onready var chainend_1: Marker3D = $chainpos/chainend1
@onready var chainend_2: Marker3D = $chainpos/chainend2
@onready var inactivity: Timer = $inactivity
@onready var match_win_test: CanvasLayer = $match_win_test
@onready var match_tie_test: CanvasLayer = $match_tie_test
@onready var match_loss_test: CanvasLayer = $match_loss_test
@onready var spell_menu = preload("res://Scenes/spell_menu.tscn")

var chain_cooldown = 10
var chain_distance = 1

var tween : Tween

var selectable_creatures_array : Array
var selected_creature_stats : Array

var enemy_creature_name : String

var bounty1 : int 
var bounty2 : int

var match_started := false
var match_ended := false
var player_bet_creature 
var non_player_bet_creature

var player_bet_died := false
var non_bet_died := false

var available_mars := 1

func _ready() -> void:
	Globals.is_betting = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	##Chooses 5 homunculi to list
	for slot in creatures.get_children():
		var creature_name : String
		var creature_dir_type : String
		var creature_atk_type : String
		var creature_price : int
		var creature_type_picker := randi_range(1, 5)
		##Direction AI types
		match creature_type_picker:
			1:
				creature_dir_type = "Simple"
				creature_name = "Simple "
			2:
				creature_dir_type = "Drunk"
				creature_name = "Drunk "
			3:
				creature_dir_type = "Crableg"
				creature_name = "Crableg "
			4:
				creature_dir_type = "Jabber"
				creature_name = "Jabber "
			5:
				creature_dir_type = "Focused"
				creature_name = "Focused "
			
		creature_type_picker = randi_range(1, 5)
		##Attack AI types
		match creature_type_picker:
			1:
				creature_atk_type = "Cautious"
				creature_name += "Cautious "
			2:
				creature_atk_type = "Hard-Headed"
				creature_name += "Hard-Headed "
			3:
				creature_atk_type = "Purist"
				creature_name += "Purist "
			4:
				creature_atk_type = "Gambler"
				creature_name += "Gambler "
			5:
				creature_atk_type = "Tickler"
				creature_name += "Tickler "
		var name_picker = randi_range(1, 100)
		##Easter egg lmao
		if name_picker != 100:
			creature_name += "Homunculus"
		else:
			creature_name += "Heitor"
		##Random price
		creature_price = randi_range(5, 10) * 10
		##Adds each homunculus to an array
		selectable_creatures_array.append([creature_name, creature_price])
		##Making it appear on screen
		update_slot_info(slot)

func _process(delta: float) -> void:
	if match_started and !match_ended:
		##Chain positioning
	
		var distance_between : float = player_bet_creature.global_transform.origin.distance_to(non_player_bet_creature.global_transform.origin)
		var scale_needed = distance_between / 1.5
		var midpoint : Vector3 = (player_bet_creature.global_position + non_player_bet_creature.global_position) / 2
		chain.global_position = midpoint + Vector3(0, 1, 0)
		chainpos.global_position = chain.global_position
		chainpos.rotation = chain.rotation
		chainend_1.position = Vector3(chain_distance * -1, -1.02, 0)
		chainend_2.position = Vector3(chain_distance, -1.02, 0)
		chain.rotation_degrees.y = player_bet_creature.rotation_degrees.y + 90
		chain.scale.x = scale_needed
		
		##Makes the (Your Choice) label visible
		player_bet_creature.yourbet.visible = true
		
		if Input.is_action_just_pressed("tab") and available_mars > 0:
			available_mars -= 1
			spell_cast("Mars")
		
		if !match_ended:
			if non_player_bet_creature.dead:
				non_bet_died = true
				end_match()
			if player_bet_creature.dead:
				player_bet_died = true
				end_match()

func update_slot_info(which):
	##Changes the name label on the slot
	which.get_child(1).text = selectable_creatures_array[creatures.get_children().find(which)][0]

##Makes the selection appear on the left
func select_creature(button):
	if !selec_desc.get_child(0).visible:
		selec_desc.get_child(0).visible = true
		selec_desc.get_child(2).visible = true
	selected_creature_stats.clear()
	selected_creature_stats.append(selectable_creatures_array[int(button.get_parent().name.replace("slot", "")) - 1])
	selec_desc.get_child(1).text = \
	selected_creature_stats[0][0]
	selec_stats.get_child(0).text = \
	str(selected_creature_stats[0][1]) + " Gold"

func bet_on_creature():
	bounty1 = selected_creature_stats[0][1]
	##Erase the player selection from the array to choose an enemy
	selectable_creatures_array.erase(selected_creature_stats[0])
	
	##Choosing the enemy
	var picked_enemy = randi_range(0, 3)
	enemy_creature_name = selectable_creatures_array[picked_enemy][0]
	bounty2 = selectable_creatures_array[picked_enemy][1]

	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(ui.get_child(0), "position", Vector2(0, -648), 1.5)
	await get_tree().create_timer(1.5).timeout
	start_match()

func start_match():
	add_child(spell_menu.instantiate())
	##Instantiating the player homunculus
	MusicPlayer.fighttheme.play()
	var player_homunculus = homunculus.instantiate()
	warcry_sfx()
	player_homunculus.name = selected_creature_stats[0][0]
	var split_stats = selected_creature_stats[0][0].split(" ", true, 2)
	player_homunculus.dir_type = split_stats[0]
	player_homunculus.atk_type = split_stats[1]
	
	##Instantiating the enemy
	var enemy_homunculus = homunculus.instantiate()
	enemy_homunculus.name = enemy_creature_name
	var split_enemy_stats = enemy_creature_name.split(" ", true, 2)
	enemy_homunculus.dir_type = split_enemy_stats[0]
	enemy_homunculus.atk_type = split_enemy_stats[1]
	
	##Making them look at each other
	player_homunculus.enemy = enemy_homunculus
	enemy_homunculus.enemy = player_homunculus
	
	add_child(player_homunculus)
	player_bet_creature = player_homunculus
	player_bet_creature.bounty = bounty1
	player_homunculus.global_position = homun_1_spawn.global_position
	player_homunculus.match_stats()
	
	add_child(enemy_homunculus)
	non_player_bet_creature = enemy_homunculus
	non_player_bet_creature.bounty = bounty2
	enemy_homunculus.global_position = homun_2_spawn.global_position
	enemy_homunculus.match_stats()
	
	match_started = true
	$inactivity.start()
func warcry_sfx():
	var which = randi_range(1, 3)
	match which:
		1:
			HomunculosSfx.galunga.play()
		2:
			HomunculosSfx.oblong.play()
		3:
			HomunculosSfx.ungus.play()



func chain_pull():
	if !match_ended:
		tween = create_tween()
		tween.set_trans(Tween.TRANS_QUART)
		tween.set_ease(Tween.EASE_IN)
		tween.tween_property(chain, "modulate", Color(1, 1, 1, 1), 0.25)
		tween.set_trans(Tween.TRANS_LINEAR)
		player_bet_creature.chained = true
		non_player_bet_creature.chained = true
		tween.tween_property(chain, "global_position", chain.global_position + Vector3(0.1, 0.1, 0), 0.02)
		tween.tween_property(chain, "global_position", chain.global_position + Vector3(-0.2, -0.2, 0), 0.02)
		tween.tween_property(chain, "global_position", chain.global_position + Vector3(0, 0.2, 0), 0.02)
		tween.tween_property(chain, "global_position", chain.global_position + Vector3(0.2, -0.2, 0), 0.02)
		tween.tween_property(chain, "global_position", chain.global_position + Vector3(0, 0.2, 0), 0.02)
		tween.tween_property(chain, "global_position", chain.global_position + Vector3(-0.2, -0.2, 0), 0.02)
		tween.tween_property(chain, "global_position", chain.global_position + Vector3(0, 0.2, 0), 0.02)
		tween.tween_property(chain, "global_position", chain.global_position + Vector3(0.2, -0.2, 0), 0.02)
		tween.tween_property(chain, "global_position", chain.global_position + Vector3(-0.1, 0.1, 0), 0.02)
		tween.set_parallel(true)
		tween.tween_property(chain, "modulate", Color(1, 1, 1, 0), 0.5)
		tween.tween_property(player_bet_creature, "global_position", chainend_1.global_position, 0.75)
		tween.tween_property(non_player_bet_creature, "global_position", chainend_2.global_position, 0.75)
		await get_tree().create_timer(1.5).timeout
		player_bet_creature.chained = false
		player_bet_creature.sprite.play("default")
		non_player_bet_creature.chained = false
		non_player_bet_creature.sprite.play("default")
		inactivity.start(chain_cooldown)
func chain_sfx():
	var which = randi_range(1, 2)
	match which:
		1:
			HomunculosSfx.homunc_chain.play()
		2:
			HomunculosSfx.homunc_chain_2.play()

	
func spell_cast(spell):
	if Globals.check_spell_available(spell):
		SpellSounds.feitiço_sfx.play()
		Globals.cooldown_spell(spell)
		##Choosing if mars worked or not
		var spell_worked = randi_range(1, 4)
		if spell_worked == 4:
			player_bet_creature.failed_mars()
		else:
			player_bet_creature.mars()

func end_match():
	match_ended = true
	if Globals.aqua_regia_timer.time_left > 0 and Globals.is_betting == true:
		player_bet_creature.bounty *= 2
		non_player_bet_creature.bounty *= 2
	MusicPlayer.fighttheme.stop()
	if player_bet_died and !non_bet_died:
		Globals.money -= player_bet_creature.bounty
		
		loss_screen(player_bet_creature.bounty)
		MusicPlayer.jingle_derrota.play()

	elif player_bet_died and non_bet_died:
		var half_bet = (player_bet_creature.bounty + non_player_bet_creature.bounty) / 2
		Globals.money -= player_bet_creature.bounty
		Globals.money += half_bet
		tie_screen(half_bet)
		MusicPlayer.jingle_derrota.play()
	elif !player_bet_died and non_bet_died:
		Globals.money += non_player_bet_creature.bounty
		win_screen(non_player_bet_creature.bounty)
		MusicPlayer.jingle_vitoria.play()

func win_screen(money_won):
	match_win_test.money_won = money_won
	match_win_test.visible = true
	var node = match_win_test.get_child(0)
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(node, "scale", Vector2(1, 1), 2)
	tween.tween_property(node, "position", Vector2.ZERO, 2)
	await get_tree().create_timer(1).timeout
	match_win_test.win_anim()

func tie_screen(money_won):
	match_tie_test.money_won = money_won
	match_tie_test.visible = true
	var node = match_tie_test.get_child(0)
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(node, "scale", Vector2(1, 1), 2)
	tween.tween_property(node, "position", Vector2.ZERO, 2)
	await get_tree().create_timer(1).timeout
	match_tie_test.win_anim()

func loss_screen(money_lost):
	match_loss_test.money_lost = money_lost
	match_loss_test.visible = true
	var node = match_loss_test.get_child(0)
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(node, "scale", Vector2(1, 1), 2)
	tween.tween_property(node, "position", Vector2.ZERO, 2)
	await get_tree().create_timer(1).timeout
	match_loss_test.loss_anim()

func _on_selec_bet_pressed() -> void:
	bet_on_creature()

func _on_inactivity_timeout() -> void:
	chain_pull()
	chain_sfx()
	if chain_distance - 0.2 > 0.5:
		chain_distance -= 0.2
	if chain_cooldown - 2 > 0:
		chain_cooldown -= 2
