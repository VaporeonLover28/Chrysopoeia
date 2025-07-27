extends Area3D

@onready var prompt : Node3D = $input_prompt
var player_inside : bool = false

func _process(delta: float) -> void:
	if player_inside:
		prompt.visible = true
	else:
		prompt.visible = false

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		player_inside = true

func _on_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		player_inside = false
