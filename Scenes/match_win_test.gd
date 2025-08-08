extends CanvasLayer

@onready var money_won_label: Label = $Money_Won_Label

var money_won : int = 300
var money_won_progress := 0

var tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1).timeout
	win_anim()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	money_won_label.text = "+" + str(money_won_progress) + " Gold" + "!".repeat(money_won_progress / 60)

func win_anim():
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "money_won_progress", money_won, 3)
