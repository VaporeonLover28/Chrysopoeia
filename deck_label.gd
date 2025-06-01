extends RichTextLabel

@onready var game: Control = $"../.."

func _process(delta: float) -> void:
	text = str(game.deck)
