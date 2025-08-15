extends CanvasLayer

@onready var match_ended: RichTextLabel = $Match_Ended
@onready var result: RichTextLabel = $Result
@onready var result_labels: VBoxContainer = $result_labels
@onready var res_player_0: RichTextLabel = $result_labels/res_player_0
@onready var res_player_1: RichTextLabel = $result_labels/res_player_1
@onready var res_player_2: RichTextLabel = $result_labels/res_player_2
@onready var res_player_3: RichTextLabel = $result_labels/res_player_3
@onready var res_player_4: RichTextLabel = $result_labels/res_player_4
@onready var res_dealer: RichTextLabel = $result_labels/res_dealer

var tween : Tween

func _ready():
	match_end_anim()

#func _process(delta: float) -> void:
	#fade_label_text(match_ended, "MATCH OVER", me_fade_end)
	#fade_label_text(result, "RESULTS", re_fade_end)
	#fade_label_text(res_player_0, "Player 0 had XX Gold and XXXX                         Player 0 net gold: +XX", npc0_fade_end)
	#fade_label_text(res_player_1, "Player 1 had XX Gold and XXXX                         Player 1 net gold: +XX", npc1_fade_end)
	#fade_label_text(res_player_2, "Player 2 had XX Gold and XXXX                         Player 2 net gold: +XX", npc2_fade_end)
	#fade_label_text(res_player_3, "Player 3 had XX Gold and XXXX                         Player 3 net gold: +XX", npc3_fade_end)
	#fade_label_text(res_player_4, "Player 4 had XX Gold and XXXX                         Player 4 net gold: +XX", npc4_fade_end)

func match_end_anim():
	await get_tree().create_timer(0.5).timeout
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_LINEAR)
	color_label(match_ended)
	tween.tween_property(match_ended, "visible_ratio", 1, 1)
	tween.tween_interval(0.5)
	color_label(result)
	tween.tween_property(result, "visible_ratio", 1, 0.5)
	tween.tween_interval(1)
	for label in result_labels.get_children():
		color_label(label)
		tween.tween_property(label, "visible_ratio", 1, 1.5)
		tween.tween_interval(0.5)
	color_label(res_dealer)
	tween.tween_property(result, "visible_ratio", 1, 0.5)

func color_label(label):
	var current_text = label.text
	label.text = "[color=SaddleBrown]" + current_text + "[/color]"
