extends Node3D

@onready var partic = $partic
@onready var plane = $Plane

var tween : Tween
var speed : float = 0
var alpha : float = 0
var emiss : float = 0

func _process(delta):
	plane.mesh.surface_get_material(0).albedo_color = Color(0.733, 0.0, 1.0, alpha)
	plane.mesh.surface_get_material(0).emission_energy_multiplier = emiss
	rotation.y += deg_to_rad(speed)

func anim():
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_parallel(true)
	tween.tween_property(self, "alpha", 1, 5)
	tween.tween_property(self, "emiss", 8.42, 5)
	tween.tween_property(self, "speed", 7, 5)
	tween.tween_property(partic, "amount_ratio", 1, 5)
	tween.set_parallel(false)
	tween.tween_callback(func():speed = 0)
	tween.tween_interval(1)
	tween.set_parallel(false)
	tween.tween_callback(func():retract())

func retract():
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_parallel(true)
	tween.tween_property(self, "alpha", 0, 0.5)
	tween.tween_property(self, "emiss", 0, 0.5)
	tween.tween_property(self, "speed", 0, 0.5)
	tween.tween_property(partic, "amount_ratio", 0, 0.5)
