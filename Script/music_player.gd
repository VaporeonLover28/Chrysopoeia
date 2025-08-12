extends Node

@onready var blackjacktheme: AudioStreamPlayer = $blackjack_theme
@onready var fulltavern: AudioStreamPlayer = $full_tavern
@onready var greensleeves: AudioStreamPlayer = $Greensleeves
@onready var fighttheme: AudioStreamPlayer =  $fight_theme
@onready var menutheme: AudioStreamPlayer = $menu_theme
@onready var emptytavern: AudioStreamPlayer = $empty_tavern


func play(audio: AudioStream, single = false) -> void:
	if not audio:
		return
	if single:
		stop()
	for player:AudioStreamPlayer in get_children():
		if not player.playing:
			player.stream = audio
			player.play()
			return
			
func stop():
	for player:AudioStreamPlayer in get_children():
		player.stop()
