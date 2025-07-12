extends Node3D 
class_name Level

@export var level_num := 0

signal objetivo_cumprido(num_objetivo:int)

@onready var _lvl_unidades :Array = get_children().filter(is_unidade) as Array[Unidade]
@onready var _lvl_estruturas :Array[Node] = get_children().filter(is_estrutura)
@onready var _lvl_recursos :Array[Node] = get_children().filter(is_recurso)

@onready var _viewport_2_din_3d: XRToolsViewport2DIn3D = $Viewport2Din3D

func _on_terminar_level():
	var lvl_texto :Label= _viewport_2_din_3d.get_scene_instance().find_child("Label")
	lvl_texto.text = "SUCESSO"
	lvl_texto.label_settings.font_color = Color.CHARTREUSE
	objetivo_cumprido.emit(level_num)

func is_unidade(node:Node)->bool:
	return node.is_in_group("Unidade")

func is_estrutura(node:Node)->bool:
	return node.is_in_group("Estrutura")

func is_recurso(node:Node)->bool:
	return node.is_in_group("Recurso")
