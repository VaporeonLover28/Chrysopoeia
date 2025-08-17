extends CanvasLayer

@onready var bg: AnimatedSprite2D = $bg
@onready var match_ended: RichTextLabel = $Match_Ended
@onready var result: RichTextLabel = $Result
@onready var result_labels: VBoxContainer = $result_labels
@onready var res_player_0: RichTextLabel = $result_labels/res_player_0
@onready var res_player_1: RichTextLabel = $result_labels/res_player_1
@onready var res_player_2: RichTextLabel = $result_labels/res_player_2
@onready var res_player_3: RichTextLabel = $result_labels/res_player_3
@onready var res_player_4: RichTextLabel = $result_labels/res_player_4
@onready var res_dealer: RichTextLabel = $res_dealer
@onready var leave: Button = $leave

var tween : Tween
var house_net : int = 0

func result_texts(player_results : Array):
	##[dealer/npc name, state, bet, net bet result]
	result_labels.get_children()[int(player_results[0])].text = "Player " +\
	player_results[0] + " had " + str(player_results[2]) + " Gold and "
	
	match player_results[1]:
		"Win":
			result_labels.get_children()[int(player_results[0])].text += "won."
		"Double Win":
			result_labels.get_children()[int(player_results[0])].text += "won with a double down!"
		"Tie":
			result_labels.get_children()[int(player_results[0])].text += "tied the dealer."
		"Loss":
			result_labels.get_children()[int(player_results[0])].text += "lost."
		"Double Loss":
			result_labels.get_children()[int(player_results[0])].text += "lost with a double down!"
		"Blackjack":
			result_labels.get_children()[int(player_results[0])].text += "won with a blackjack!"
		
	result_labels.get_children()[int(player_results[0])].get_child(0).text = \
	"Net gold: " + str(player_results[3])
	
	house_net -= int(player_results[3])
	if house_net > 0:
		res_dealer.get_child(0).text = "+" + str(house_net)
	elif house_net < 0:
		res_dealer.get_child(0).text = str(house_net)
	else:
		res_dealer.get_child(0).text = "0"

func match_end_anim():
	get_parent().player.allowed_to_move = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	bg.play("open")
	await get_tree().create_timer(2).timeout
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_LINEAR)
	vis_tween_label(match_ended, 1, 0.5)
	vis_tween_label(result, 0.5, 1)
	for label in result_labels.get_children():
		if label.text.right(4) != "XXXX":
			label.visible = true
			vis_tween_label(label, 1, 0)
			vis_tween_label(label.get_child(0), 0.5, 0.5)
	vis_tween_label(res_dealer, 0.5, 0)
	vis_tween_label(res_dealer.get_child(0), 0.25, 0)
	await get_tree().create_timer(4.25 + (result_labels.get_children().size() * 1)).timeout
	leave.visible = true

func vis_tween_label(label, time, interval):
	color_label(label)
	tween.tween_property(label, "visible_ratio", 1, time)
	tween.tween_interval(interval)

func unvis_label(label):
	tween.tween_property(label, "visible_ratio", 0, 0.75)

func color_label(label):
	if label.name != "net":
		var current_text = label.text
		label.text = "[color=SaddleBrown]" + current_text + "[/color]"
		var current_net_text = label.get_child(0).text.split(" ")
		if current_net_text[0] != "XXX":
			if current_net_text.size() != 1:
				match current_net_text[current_net_text.size() - 1].left(1):
					"+":
						label.get_child(0).text = "[color=SaddleBrown]Net gold: [/color][color=Green]"\
						 + current_net_text[current_net_text.size() - 1] + "[/color]"
					"-":
						label.get_child(0).text = "[color=SaddleBrown]Net gold: [/color][color=Red]"\
						 + current_net_text[current_net_text.size() - 1] + "[/color]"
					_:
						label.get_child(0).text = "[color=SaddleBrown]Net gold: [/color][color=White]"\
						 + current_net_text[current_net_text.size() - 1] + "[/color]"
			else:
				match current_net_text[current_net_text.size() - 1].left(1):
					"+":
						label.get_child(0).text = "[color=Green]"\
						 + current_net_text[current_net_text.size() - 1] + "[/color]"
					"-":
						label.get_child(0).text = "[color=Red]"\
						 + current_net_text[current_net_text.size() - 1] + "[/color]"
					_:
						label.get_child(0).text = "[color=White]"\
						 + current_net_text[current_net_text.size() - 1] + "[/color]"

func _on_leave_pressed() -> void:
	tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.set_parallel(true)
	unvis_label(match_ended)
	unvis_label(result)
	for label in result_labels.get_children():
		unvis_label(label)
		unvis_label(label.get_child(0))
	unvis_label(res_dealer)
	unvis_label(res_dealer.get_child(0))
	tween.set_parallel(false)
	tween.tween_interval(0.12)
	tween.tween_callback(func(): leave.visible = false)
	tween.tween_callback(bg.play_backwards.bind("open"))
	tween.tween_interval(0.67)
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(bg, "position", Vector2(576, 1141), 1)
	tween.tween_callback(func():
		Globals.money += int(house_net)
		MusicPlayer.greensleeves.stop()
		Globals.clear_cooldowns()
		Globals.return_to_world()
	)
