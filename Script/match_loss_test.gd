extends CanvasLayer

@onready var money_loss_label: Label = $Control/Money_Loss_Label
@onready var continue_button: Button = $Control/Continue

@export var anim_duration : float = 3.0

var money_lost : int
var money_lost_progress := 0

var tween : Tween

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	money_loss_label.text = "-" + str(money_lost_progress) + " Gold" + "!".repeat(money_lost_progress / 60)

func loss_anim():
	await get_tree().create_timer(1).timeout
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "money_lost_progress", money_lost, anim_duration)
	await get_tree().create_timer(anim_duration).timeout
	end_anim()

func end_anim():
	continue_button.visible = true

func _on_continue_pressed() -> void:
	Globals.return_to_world()
