extends CanvasLayer

@onready var money_won_label: Label = $Control/Money_Won_Label
@onready var continue_button: Button = $Control/Continue

@export var anim_duration : float = 3.0

var money_won : int
var money_won_progress := 0

var tween : Tween

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	money_won_label.text = "+" + str(money_won_progress) + " Gold" + "!".repeat(money_won_progress / 60)

func win_anim():
	await get_tree().create_timer(1).timeout
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "money_won_progress", money_won, anim_duration)
	await get_tree().create_timer(anim_duration).timeout
	end_anim()

func end_anim():
	continue_button.visible = true
	CoinEarned.moedas_01.play()
func _on_continue_pressed() -> void:
	Globals.return_to_world()
