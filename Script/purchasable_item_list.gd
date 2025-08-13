extends Node

@onready var games_list : Array[PurchasableItemResource]
@onready var decoration_list : Array[PurchasableItemResource] = []
@onready var spell_list : Array[PurchasableItemResource]

var item_list_level : int = 4:
	set(new_value):
		item_list_level = new_value
		update_item_list()
		
func _ready() -> void:
	update_item_list()

func update_item_list():
	match item_list_level:
		0:
			games_list = [load("res://Resources-shop/slot_mac.tres")]
		1:
			games_list = [load("res://Resources-shop/slot_mac.tres"),
			load("res://Resources-shop/black_jack.tres")]
			spell_list = [load("res://Resources-shop/spell_fortune.tres")]
		2:
			games_list = [load("res://Resources-shop/slot_mac.tres"),
			load("res://Resources-shop/black_jack.tres"),
			load("res://Resources-shop/bar.tres")]
			spell_list = [load("res://Resources-shop/spell_fortune.tres"),
			load("res://Resources-shop/spell_shard.tres"),
			load("res://Resources-shop/spell_fool.tres"),
			load("res://Resources-shop/spell_prov.tres")]
		3:
			games_list = [load("res://Resources-shop/slot_mac.tres"),
			load("res://Resources-shop/black_jack.tres"),
			load("res://Resources-shop/bar.tres"),
			load("res://Resources-shop/ring_key.tres")]
			spell_list = [load("res://Resources-shop/spell_fortune.tres"),
			load("res://Resources-shop/spell_shard.tres"),
			load("res://Resources-shop/spell_fool.tres"),
			load("res://Resources-shop/spell_prov.tres")]
		4:
			games_list = [load("res://Resources-shop/slot_mac.tres"),
			load("res://Resources-shop/black_jack.tres"),
			load("res://Resources-shop/bar.tres"),
			load("res://Resources-shop/ring_key.tres")]
			spell_list =[load("res://Resources-shop/spell_fortune.tres"),
			load("res://Resources-shop/spell_shard.tres"),
			load("res://Resources-shop/spell_fool.tres"),
			load("res://Resources-shop/spell_prov.tres"),
			load("res://Resources-shop/spell_mars.tres")]
