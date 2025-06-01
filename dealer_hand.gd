extends RichTextLabel

@onready var game: Control = $"../.."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = str(game.dealer_hand)
