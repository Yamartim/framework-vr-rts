extends Node3D
class_name Inventario

@export var _quantidade_inicial : int
var _itens :Array[Node3D]= []
var _cena_item := preload("res://pickable_teste.tscn")

@onready var _vis_cubo = $VisualCubo
@onready var _area_itens = $AreaItens
@onready var _col_shape := $AreaItens/CollisionShape3D.shape as BoxShape3D
@onready var _label: Label = $SubViewport/Label


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var cubo :BoxMesh= _vis_cubo.mesh
	var tam_cubo := cubo.size
	_col_shape.size = tam_cubo
	var bounds := tam_cubo/2
	_label.text = String.num_int64(_quantidade_inicial)

	
	for i in range(_quantidade_inicial):
		var o := _cena_item.instantiate() as Node3D

		add_child(o)
		o.position = Vector3(randf_range(-bounds.x, bounds.x),randf_range(-bounds.y, bounds.y), randf_range(-bounds.z, bounds.z))
		adicionar_item(o)


func adicionar_item(item : Node3D):
	print("add item no inventario de ", get_parent().name)
	item.axis_lock_linear_x = true 
	item.axis_lock_linear_y = true
	item.axis_lock_linear_z = true
	
	item.reparent(self)
	
	_itens.append(item)
	_label.text = String.num_int64(len(_itens))
	
	if item is XRToolsPickable:
		item.request_highlight(item.get_child(0), false)
		item.connect('picked_up', remover_item)


func remover_item(obj):
	#print(obj)
	#print(itens)
	#print(len(itens))
	if len(_itens) <= 0:
		return null
	print('removendo item!')
	var item = _itens.pop_at(_itens.find(obj))
	_label.text = String.num_int64(len(_itens))
	item.axis_lock_linear_x = false
	item.axis_lock_linear_y = false
	item.axis_lock_linear_z = false
	item.reparent(get_node("/root"))
	item.disconnect('picked_up', remover_item)

	return item

func transferir_item(to_iventario:Inventario) -> bool:
	if _itens.is_empty():
		return false
	
	var temp_pos = _itens[0].position
	var item = remover_item(_itens[0])
	
	# mover posição do item
	
	to_iventario.adicionar_item(item)
	item.position = temp_pos
	
	return true
	
#region signal callbacks

func _on_area_itens_body_entered(body: Node3D) -> void:
	print("obj entrou em area de inventario")
	if body is XRToolsPickable:
		print("conectando")
		body.connect("dropped", adicionar_item)
		body.request_highlight(body.get_child(0), true)


func _on_area_itens_body_exited(body: Node3D) -> void:
	print("obj saiu de area do inventario")
	if body is XRToolsPickable:
		print("desconectando")
		body.disconnect("dropped", adicionar_item)
		body.request_highlight(body.get_child(0), false)
#endregion
