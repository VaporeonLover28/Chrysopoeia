extends Label

var tween = Tween
@onready var title = $"."

func _process(delta: float) -> void:
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(title,"position", Vector2(138,32), 2.5)
	
