extends Node

var player_pos_save : Vector3
var game_paused: bool = false
var player_interacting: bool = false
var player_is_in_camera_animation: bool = false
var money: int = 1000:
	set(new_value):
		if aqua_philosophorum_timer.time_left > 0 and new_value <= 0:
			money += 110
			aqua_philosophorum_timer.stop()
		money = new_value

var money_lost: int = -1
var spell_inventory_list: Array[PurchasableItemResource]

var ring_unlock: bool = false

@onready var aqua_vitae_timer: Timer
@onready var aqua_fortis_active: bool = false
@onready var aqua_regia_timer: Timer
@onready var aqua_philosophorum_timer: Timer

var fortuna_in_spell_list := true
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
	
func _see_if_has_specific_spell( spell_name : String):
	for item in spell_inventory_list:
		if spell_name == item.name:
			return true
		else:
			return false

func _remove_spell( spell_name : String):
	for item in spell_inventory_list.size() - 1:
		if spell_name == spell_inventory_list[item].name:
			spell_inventory_list.remove_at(item)
		else:
			print("cannot find spell")

func _calculate_bet_loses(money_value: int):
	if money_value < 0:
		money_lost = money_value
	if money_value >= 0:
		money_lost = 0

func return_to_world():
	get_tree().change_scene_to_file("res://Scenes/world.tscn")
	$Player.global_position = player_pos_save
