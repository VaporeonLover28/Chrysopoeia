extends Node3D

var bob_amp: float = 0.05  # How high/low the movement goes
var bob_freq: float = 0.7  # How fast the oscillation happens
var start_y: float = 0.0  # Store the original Y position

func _ready():
	start_y = position.y  # Store initial Y position when node loads

func _process(delta):
	# Get current time in seconds since the game started
	var time = Time.get_ticks_msec() / 1000.0
	# Calculate vertical position using sine wave
	position.y = start_y + sin(time * bob_freq * PI) * bob_amp
