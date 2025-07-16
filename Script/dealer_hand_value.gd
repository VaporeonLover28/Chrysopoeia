extends Label

@onready var game: Control = $".."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "Value: " + str(game.dealer_hand_value)
