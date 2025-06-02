extends Node3D
class_name Inventario

@export var quantidade_inicial : int
var itens := []
var cena_item := preload("res://pickable_teste.tscn")

@onready var vis_cubo = $VisualCubo
@onready var area_itens = $AreaItens
@onready var col_shape := $AreaItens/CollisionShape3D.shape as BoxShape3D
@onready var label: Label = $Sprite3D/SubViewport/Label


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var cubo :BoxMesh= vis_cubo.mesh
	var tam_cubo := cubo.size
	col_shape.size = tam_cubo
	var bounds := tam_cubo/2
	label.text = String.num_int64(quantidade_inicial)

	
	for i in range(quantidade_inicial):
		var o := cena_item.instantiate() as Node3D
		add_child(o)
		o.position = Vector3(randf_range(-bounds.x, bounds.x),randf_range(-bounds.y, bounds.y), randf_range(-bounds.z, bounds.z))
		
		o.axis_lock_linear_x = true 
		o.axis_lock_linear_y = true
		o.axis_lock_linear_z = true
		itens.append(o)
		if o is XRToolsPickable:
			o.connect('picked_up', remover_item)


func adicionar_item(item):
	print("add item...")
	item.axis_lock_linear_x = true 
	item.axis_lock_linear_y = true
	item.axis_lock_linear_z = true
	add_child(item)
	itens.append(item)
	label.text = String.num_int64(len(itens))
	
	if item is XRToolsPickable:
		item.request_highlight(item.get_child(0), false)
		item.connect('picked_up', remover_item)


func remover_item(obj):
	#print(obj)
	#print(itens)
	#print(len(itens))
	if len(itens) <= 0:
		return null
	print('removendo item!')
	var item = itens.pop_at(itens.find(obj))
	label.text = String.num_int64(len(itens))
	item.axis_lock_linear_x = false
	item.axis_lock_linear_y = false
	item.axis_lock_linear_z = false
	item.reparent(get_node("/root"), true)
	item.disconnect('picked_up', remover_item)

	return item

func transferir_item(to_iventario:Inventario) -> bool:
	if itens.is_empty():
		return false
		
	var temp_pos = itens[0].position
	var item = remover_item(itens[0])
	
	to_iventario.adicionar_item(item)
	item.position = temp_pos
	return true

func _on_area_itens_body_entered(body: Node3D) -> void:
	print("obj entrou")
	if body is XRToolsPickable:
		print("conectando")
		body.connect("dropped", adicionar_item)
		body.request_highlight(body.get_child(0), true)


func _on_area_itens_body_exited(body: Node3D) -> void:
	print("obj saiu")
	if body is XRToolsPickable:
		print("desconectando")
		body.disconnect("dropped", adicionar_item)
		body.request_highlight(body.get_child(0), false)
