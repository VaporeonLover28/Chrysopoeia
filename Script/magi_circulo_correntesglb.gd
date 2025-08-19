extends Node3D

@onready var partic = $partic
@onready var plane = $Plane

var tween : Tween
var speed : float = 0
var alpha : float = 0
var emiss : float = 0

func _ready():
	anim()

func _process(delta):
	plane.mesh.surface_get_material(0).albedo_color = Color(0.733, 0.0, 1.0, alpha)
	plane.mesh.surface_get_material(0).emission_energy_multiplier = emiss
	rotation.y += deg_to_rad(speed)

func anim():
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_parallel(true)
	tween.tween_property(self, "alpha", 1, 5)
	tween.tween_property(self, "emiss", 8.42, 10)
	tween.tween_property(self, "speed", 7, 5)
	tween.tween_property(partic, "amount_ratio", 1, 10)
	tween.set_parallel(false)
	tween.tween_interval(5)
	tween.tween_callback(func():tween.stop())
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(func():speed = 0)
	tween.tween_interval(1)
	tween.set_parallel(false)
	tween.set_parallel(true)
	tween.tween_property(self, "alpha", 0, 0.5)
	tween.tween_property(self, "emiss", 0, 0.5)
	tween.tween_property(self, "speed", 0, 0.5)
	tween.tween_property(partic, "amount_ratio", 0, 0.5)
