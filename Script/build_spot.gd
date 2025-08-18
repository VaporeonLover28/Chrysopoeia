extends Marker3D

@export_enum("Camera Pullers", "Doors", "Ground_object") var object_type : String
@onready var world = get_tree().root.get_node("World")
@onready var area: Area3D = $"Area build spot"
@onready var mesh: MeshInstance3D = $"Build Mesh"

var taken := false

var color_free := Color.hex(0x00ff0056)
var color_taken := Color.hex(0xff000056)

@onready var on_or_off: bool = false

func _ready() -> void:
	mesh.visible = false
	#print(mesh.mesh.surface_get_material(0).albedo_color != color_free)
	area.add_to_group(object_type)
	area.monitoring = false
	area.monitoring = true
	world.update_all_mesh.connect(update_mesh)

func update_mesh():
	if taken and mesh.mesh.surface_get_material(0).albedo_color != color_taken:
		mesh.mesh.surface_get_material(0).albedo_color = color_taken
	elif !taken and mesh.mesh.surface_get_material(0).albedo_color != color_free:
		mesh.mesh.surface_get_material(0).albedo_color = color_free
	
	if !on_or_off:
		mesh.visible = true
		on_or_off = true
	else:
		mesh.visible = false
		on_or_off = false
		
