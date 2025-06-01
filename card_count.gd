extends Label

@onready var game: Control = $".."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "Card count: " + str(game.deck.size())
