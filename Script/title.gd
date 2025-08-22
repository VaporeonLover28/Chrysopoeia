extends Label

var started : bool = false
@onready var title = $"."
var bob_amp: float = 0.02  # How high/low the movement goes
var bob_freq: float = 0.7  # How fast the oscillation happens
var start_scale: float = 1.0  # Store the original Y position
var tween = Tween
func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	tween = create_tween()
	tween.set_trans(Tween.TRANS_QUINT)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(title,"position", Vector2(289,32), 2.5)
	started = true

func _process(delta: float) -> void:
	if started:
		# Get current time in seconds since the game started
		var time = Time.get_ticks_msec() / 1000.0
		# Calculate vertical position using sine wave
		scale.x = start_scale + sin(time * bob_freq * PI) * bob_amp
		scale.y = start_scale + sin(time * bob_freq * PI) * bob_amp
		rotation_degrees = start_scale + sin(time * bob_freq * PI * 2) * bob_amp * 15
