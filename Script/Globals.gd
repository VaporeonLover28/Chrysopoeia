extends Node

var game_paused: bool = false
var player_interacting: bool = false
var player_is_in_camera_animation: bool = false
var money: int = 0
var spell_inventory_list: Array[PurchasableItemResource] = [] 
@export var something: int

var player_transform_storage: Array
