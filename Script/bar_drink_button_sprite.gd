extends TextureButton

@onready var box = $"../"
@onready var ui = $"../../../../../../"

func _on_pressed() -> void:
	match box.drink_name:
		"Aqua Vitae":
			box.description = "After a bet, restore 25% of gold spent.\nIf bet was won, get 50 extra gold."
		"Aqua Fortis":
			box.description = "2 for 1.\nSlot machines spin twice per bet."
		"Aqua Regia":
			box.description = "All game winnings (and losses!) get doubled."
		"Aqua Philosophorum":
			box.description = "Gold safeguard.\nGain 110 gold if you lose all your money."
	
	ui.select_drink(box)
