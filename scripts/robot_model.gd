extends Node3D 
class_name RobotModel

@export var _meshes: Array[MeshInstance3D] = []
#@export var _material: Material = null

@onready var _anim:AnimationPlayer = $AnimationPlayer

var _outline_selec := 6.0
var _outline_unselec := 0.0

func _ready() -> void:
	_anim.autoplay = "RobotArmature|Robot_Idle"

func mostrar_outline(toggle:bool):
	var outline_val := _outline_selec if toggle else _outline_unselec
	for mesh_i in _meshes:
		mesh_i.get_surface_override_material(0).next_pass.set('shader_parameter/outline_width', outline_val)
		if mesh_i.get_surface_override_material_count() > 1:
			mesh_i.get_surface_override_material(1).next_pass.set('shader_parameter/outline_width', outline_val)

func anim_idle():
	if _anim.current_animation != "RobotArmature|Robot_Idle":
		_anim.play("RobotArmature|Robot_Idle")

func anim_walk():
	if _anim.current_animation != "RobotArmature|Robot_Walking":
		_anim.play("RobotArmature|Robot_Walking")

func anim_interact():
	_anim.play("RobotArmature|Robot_Punch")
