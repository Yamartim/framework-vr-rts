extends Node3D

@export var quantidade := 3
var itens := []
var obj := preload("res://pickable_teste.tscn")
var raio_spawn = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(quantidade):
		var o := obj.instantiate()
		add_child(o)
		o.position = Vector3(randf_range(-raio_spawn, raio_spawn),
							randf_range(-raio_spawn, raio_spawn), 
							randf_range(-raio_spawn, raio_spawn))
		o.axis_lock_linear_x = true 
		o.axis_lock_linear_y = true
		o.axis_lock_linear_z = true
		itens.append(o)
		if o is XRToolsPickable:
			o.connect('picked_up', remover_item)


func adicionar_item(item):
	item.axis_lock_linear_x = true 
	item.axis_lock_linear_y = true
	item.axis_lock_linear_z = true
	add_child(item)
	itens.append(item)
	quantidade += 1
	
func remover_item(obj):
	if quantidade <= 0:
		return null
	var item = itens.pop_at(itens.find(obj))
	item.axis_lock_linear_x = false
	item.axis_lock_linear_y = false
	item.axis_lock_linear_z = false
	item.reparent(get_node("/root"), true)
	item.disconnect('picked_up', remover_item)
	quantidade -= 1
	return item
