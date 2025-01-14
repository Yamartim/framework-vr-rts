class_name Unidade extends CharacterBody3D

signal escolhida
signal desescolhida

#PRECISA ter um sinal com esse nome pro pointer event emitir
signal pointer_event(event:XRToolsPointerEvent)

@onready var meshinst : MeshInstance3D = get_node("MeshInstance3D") 
@onready var selecionado : bool = false
@onready var alvo : Vector3 = position

func _ready():
	connect("escolhida", %diretor._on_unidade_escolhida)
	connect("desescolhida", %diretor._on_unidade_desescolhida)
	
	pointer_event.connect(_on_pointer_event)

	set_seleção(false)
	
	


#func _on_input_event(camera, event:InputEvent, event_position, normal, shape_idx):
	#if event.is_action_pressed("L_click"):
		#print(name, ' foi clicado')
		#set_seleção(!selecionado)
		#

func set_seleção(selec: bool):
	selecionado = selec
	if selecionado:
		meshinst.mesh.surface_get_material(0).next_pass.set('shader_parameter/outline_width', 3.0)
		escolhida.emit(self)

	else: 
		meshinst.mesh.surface_get_material(0).next_pass.set('shader_parameter/outline_width', 0.0)
		desescolhida.emit(self)


func _on_diretor_mandar_ordem(posicao):
	if selecionado:
		alvo = posicao
		set_seleção(false)
	

func _process(delta):
	#movimento provisorio, dps mudar pra agentes e navmesh
	if alvo.distance_to(position)>1:
		position = lerp(position, Vector3(alvo.x,position.y,alvo.z), 1*delta)
		





func _on_pointer_event(event):
	if event.event_type == event.Type.PRESSED:
		print("pointer event ", event)
		print(name, ' foi clicado pelo pointer VR!')
		set_seleção(!selecionado)
