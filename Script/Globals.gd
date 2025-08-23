extends Node

var player_pos_save : Vector3
var game_paused: bool = false

var player_interacting: bool = false
var player_is_in_camera_animation: bool = false
var is_betting : bool = false
var money: int = 10000:
	set(new_value):
		if (new_value - money) < 0 and is_betting == true:
			money_lost = (new_value - money)
		elif (new_value - money) > 0 and is_betting == true:
			money_lost = 0
		if aqua_vitae_timer.time_left > 0 and (new_value - money) <= money and is_betting == true:
			new_value += (new_value - money) * 4 / 100
			aqua_vitae_timer.stop()
		if aqua_philosophorum_timer.time_left > 0 and new_value <= 0:
			new_value = 110
			aqua_philosophorum_timer.stop()
		if aqua_regia_timer.time_left > 0 and is_betting == true:
			aqua_regia_timer.stop()
		money = new_value
		if get_parent().get_node_or_null("World") != null and SaveScript.is_loading == false:
			SaveScript.auto_save.emit()

var save_money: int = 0

var satisfaction_level: int = 0:
	set(new_value):
		satisfaction_level = new_value
		get_parent().get_node("PurchasableItemList").update_item_list()

var transiting_characters_to_gamble: Array[Array]  
var save_npcs_pos: Array[Array]
var save_objects: Array[Array]
var save_player_pos: Vector3 = Vector3()
var save_build_spot : Array

var money_lost: int = 8
var spell_inventory_list: Array[PurchasableItemResource]

var bar_unlock: bool = false
var ring_unlock: bool = false

@onready var aqua_vitae_timer: Timer
@onready var aqua_fortis_active: bool = false
@onready var aqua_regia_timer: Timer
@onready var aqua_philosophorum_timer: Timer

var fortuna_target : Node3D

func _ready() -> void:
	var aqua_vitae_timer_inst = Timer.new()
	aqua_vitae_timer_inst.one_shot = true
	aqua_vitae_timer_inst.name = "Aqua Vitae Timer"
	aqua_vitae_timer = aqua_vitae_timer_inst
	self.add_child(aqua_vitae_timer_inst)
	
	var aqua_regia_timer_inst = Timer.new()
	aqua_regia_timer_inst.one_shot = true
	aqua_regia_timer_inst.name = "Aqua Regia Timer"
	aqua_regia_timer = aqua_regia_timer_inst
	self.add_child(aqua_regia_timer_inst)
		
	var aqua_philosophorum_timer_inst = Timer.new()
	aqua_philosophorum_timer_inst.one_shot = true
	aqua_philosophorum_timer_inst.name = "Aqua philosophorum Timer"
	aqua_philosophorum_timer = aqua_philosophorum_timer_inst
	self.add_child(aqua_philosophorum_timer_inst)
	
func check_spell_available(spell_name : String):
	if spell_inventory_list.size() > 0:
		var spell_found := false
		var spell_not_cd := false
		for spell in spell_inventory_list:
			if !spell_found:
				if spell_name == spell.name:

					spell_found = true
					if spell.usable:
						spell_not_cd = true
						print("spell available")
					else:
						print("spell in inv, on cooldown")
				else:
					print("not " + spell_name)
		if spell_found and spell_not_cd:
			return true
		else:
			return false

func limit_spells(allowed_spells : Array):
	##allowed spells array contains names
	##i.e. ["Eye of Providence", "Mars"]
	
	##temporarily disables all spells in inv
	for spell in spell_inventory_list:
		spell.usable = false
		##if the spell is one of the allowed ones
		for allowed in allowed_spells:
			if spell.name == allowed:
				##turn it back on
				spell.usable = true
	##not allowed spells will remain unusable

func cooldown_spell(spell_name : String):
	for spell in spell_inventory_list:
		if spell_name == spell.name:
			spell.usable = false
		#else:
			#print("not desired spell")

func clear_cooldowns():
	for spell in spell_inventory_list:
		if !spell.usable:
				spell.usable = true

func _remove_spell(spell_name : String):
	for spell in spell_inventory_list:
		if spell_name == spell.name:
			spell_inventory_list.erase(spell)
		#else:
			#print("cannot find spell")

func _calculate_bet_loses(money_value: int):
	if money_value < 0:
		money_lost = money_value
	if money_value >= 0:
		money_lost = 0

func return_to_world():
	player_interacting = false
	clear_cooldowns()
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func fortuna_sounds():
	var which_one = randi_range(1, 2)	
	match which_one:
		1:
			SpellSounds.fortuna_01.play()
		2:
			SpellSounds.fortuna_01.play()
func prov_sounds():
	var which_one = randi_range(1, 2)	
	match which_one:
		1:
			SpellSounds.ad_maiorem_01.play()
		2:
			SpellSounds.ad_maiorem_02.play()
func shard_sounds():
	var which_one = randi_range(1, 2)	
	match which_one:
		1:
			SpellSounds.sapere_aude_01.play()
		2:
			SpellSounds.sapere_aude_02.play()
func mars_sounds():
	var which_one = randi_range(1, 2)	
	match which_one:
		1:
			SpellSounds.bellum_01.play()
		2:
			SpellSounds.bellum_02.play()
func fgold_sounds():
	var which_one = randi_range(1, 2)	
	match which_one:
		1:
			SpellSounds.auri_sacra_01.play()
		2:
			SpellSounds.auri_sacra_02.play()
