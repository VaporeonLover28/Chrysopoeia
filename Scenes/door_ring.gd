extends CSGBox3D

signal buyed_rign_key

@onready var navigation_region_3d: NavigationRegion3D = $"../.."


func _ready() -> void:
	if Globals.ring_unlock == true:
		_remove_wall()
		
func _remove_wall():
	print("remove door")
	self.visible = true
	navigation_region_3d.bake_navigation_mesh()
