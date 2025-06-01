extends Node3D 
class_name RobotModel

@export var meshes: Array[MeshInstance3D] = []
@export var material: Material = null

var outline_selec := 4.0
var outline_unselec := 0.0

func mostrar_outline(toggle:bool):
	var outline_val := outline_selec if toggle else outline_unselec
	for mesh_i in meshes:
		mesh_i.get_surface_override_material(0).next_pass.set('shader_parameter/outline_width', outline_val)
		if mesh_i.get_surface_override_material_count() > 1:
			mesh_i.get_surface_override_material(1).next_pass.set('shader_parameter/outline_width', outline_val)
