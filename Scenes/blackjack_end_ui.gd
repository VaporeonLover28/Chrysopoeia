extends CanvasLayer

@onready var match_ended: RichTextLabel = $Match_Ended
@onready var result: Label = $result_labels/Result
@onready var res_player_0: Label = $result_labels/res_player_0
@onready var res_player_1: Label = $result_labels/res_player_1
@onready var res_player_2: Label = $result_labels/res_player_2
@onready var res_player_3: Label = $result_labels/res_player_3
@onready var res_player_4: Label = $result_labels/res_player_4
@onready var res_dealer: Label = $result_labels/res_dealer

var tween : Tween

var fade_end : int = 0

func _ready() -> void:
	match_end_anim()

func _process(delta: float) -> void:
	match_ended.text = "[fade start=0 length=" + str(fade_end) + "]MATCH OVER[/fade]"

func match_end_anim():
	await get_tree().create_timer(0.75).timeout
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "fade_end", 40, 1.75)
	tween.t
