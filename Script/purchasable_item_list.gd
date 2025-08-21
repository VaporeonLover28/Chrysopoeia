extends Node


@onready var all_games_list : Array[PurchasableItemResource] = [load("res://Resources-shop/slot_mac.tres"),
load("res://Resources-shop/black_jack.tres"),
load("res://Resources-shop/bar.tres"),
load("res://Resources-shop/ring_key.tres")]

@onready var all_decoration_list : Array[PurchasableItemResource] = \
[load("res://Resources-shop/Candlestick.tres"),\
load("res://Resources-shop/chair.tres"),\
load("res://Resources-shop/chandelier.tres"),
load("res://Resources-shop/table.tres")]

@onready var all_spell_list : Array[PurchasableItemResource] = [load("res://Resources-shop/spell_fortune.tres"),
load("res://Resources-shop/spell_shard.tres"),
load("res://Resources-shop/spell_fool.tres"),
load("res://Resources-shop/spell_prov.tres"),
load("res://Resources-shop/spell_mars.tres")]

@onready var games_list : Array[PurchasableItemResource] = []
@onready var decoration_list : Array[PurchasableItemResource] = []
@onready var spell_list : Array[PurchasableItemResource] = []

@onready var removed_itens: Array
@onready var added_itens: Array

@onready var shop_level : int = 0

var item_list_level : int = -1:
	set(new_value):
		item_list_level = new_value
		update_item_list()
		
func _ready() -> void:
	update_item_list()

func update_item_list():
	added_itens = []
	removed_itens = []
	if Globals.satisfaction_level >= 0 and Globals.satisfaction_level < 10 and shop_level != 1:
		print("by")
		_filter_to_add(games_list, [load("res://Resources-shop/slot_mac.tres")])
		_filter_to_add(decoration_list, [load("res://Resources-shop/table.tres")])
		_filter_to_add(spell_list, [load("res://Resources-shop/spell_fortune.tres")])
		_filter_to_remove(games_list, [load("res://Resources-shop/black_jack.tres")])
		_filter_to_remove(decoration_list, [load("res://Resources-shop/chair.tres"), load("res://Resources-shop/Candlestick.tres")])
		_filter_to_remove(spell_list, [load("res://Resources-shop/spell_prov.tres")])
		shop_level = 1
	if Globals.satisfaction_level >= 35 and shop_level != 2:
		_filter_to_add(games_list, [load("res://Resources-shop/black_jack.tres")])
		_filter_to_add(decoration_list, [load("res://Resources-shop/chair.tres"), load("res://Resources-shop/Candlestick.tres")])
		_filter_to_add(spell_list, [load("res://Resources-shop/spell_prov.tres")])
		_filter_to_remove(decoration_list, [load("res://Resources-shop/Candlestick.tres")])
		_filter_to_remove(spell_list, [load("res://Resources-shop/spell_shard.tres"), load("res://Resources-shop/spell_fool.tres")])
		shop_level = 2
	if Globals.satisfaction_level >= 120 and shop_level != 3:
		if Globals.bar_unlock == false:
			_filter_to_add(games_list, [load("res://Resources-shop/bar.tres")])
		_filter_to_add(decoration_list, [load("res://Resources-shop/Candlestick.tres")])
		_filter_to_add(spell_list, [load("res://Resources-shop/spell_shard.tres"), load("res://Resources-shop/spell_fool.tres")])
		_filter_to_remove(spell_list, [load("res://Resources-shop/spell_mars.tres")])
		shop_level = 3
	if Globals.satisfaction_level >= 250 and shop_level != 4:
		if Globals.ring_unlock == false:
			_filter_to_add(games_list, [load("res://Resources-shop/ring_key.tres")])
		#_filter_to_add(decoration_list, [load("res://Resources-shop/Candlestick.tres")])
		_filter_to_add(spell_list, [load("res://Resources-shop/spell_mars.tres")])
		shop_level = 4
		
	if get_parent().get_node_or_null("World") != null:
		$"../World/Shop Menu/Shop".update_shop_contents.emit(_sort_by_type(added_itens), _sort_by_type(removed_itens))
		

func _filter_to_add(type_of_list: Array , objects_to_be_added: Array):
	for item in objects_to_be_added:
		print(item)
		if type_of_list.has(item) == false:
			print("add")
			type_of_list.append(item)
			added_itens.append(item)
	print(added_itens)
	print(decoration_list)
	
func _filter_to_remove(type_of_list: Array , objects_to_be_removed: Array):
	var array_objects_removing : Array
	for item in objects_to_be_removed:
		if type_of_list.has(item) == true:
			array_objects_removing.push_back(item)
			removed_itens.append(item)
	for item in array_objects_removing:
		type_of_list.erase(item)
	

func _sort_by_type(type_of_array: Array):
	var sorted_array : Array[Array] = []
	
	var Gl : Array = []
	for game in all_games_list:
		if type_of_array.has(game):
			Gl.push_back(game)
	sorted_array.push_back(Gl)
	
	var Dl: Array = []
	for decoration in all_decoration_list:
		if type_of_array.has(decoration):
			Dl.push_back(decoration)
	sorted_array.push_back(Dl)
	
	var Sl: Array = []
	for spell in all_spell_list:
		if type_of_array.has(spell):
			Sl.push_back(spell)
	sorted_array.push_back(Sl)
	
	return sorted_array
