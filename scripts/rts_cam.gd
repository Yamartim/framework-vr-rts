extends Camera3D

const tam_raio = 1000
var marcador:PackedScene = preload("res://cenas/marcador.tscn")

@export var vrsim := false

func _ready():
	if vrsim:
		queue_free()

func _input(event):
	if event.is_action_pressed("L_click"):
		shoot_ray()
	if event.is_action_pressed('R_click'):
		emitir_comando()

func shoot_ray():
	var mouse_pos:Vector2 = get_viewport().get_mouse_position()
	var inicio:Vector3 = project_ray_origin(mouse_pos)
	var fim:Vector3 = inicio + project_ray_normal(mouse_pos) * tam_raio
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = inicio
	ray_query.to = fim
	
	var resultado = space.intersect_ray(ray_query)
	print(resultado)
	
	
	# instancia uma esfera pra debug
	if !resultado.is_empty():
		var instancia = marcador.instantiate()
		instancia.position = resultado['position']
		add_sibling(instancia)
	
	return resultado

func emitir_comando():
	var ponto = shoot_ray()
	if ponto:
		%diretor.emit_signal("mandar_ordem", ponto['position'])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
