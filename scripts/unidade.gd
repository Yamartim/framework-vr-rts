class_name Unidade extends CharacterBody3D

signal escolhida
signal desescolhida

#PRECISA ter um sinal com esse nome pro pointer event emitir
signal pointer_event(event:XRToolsPointerEvent)

@onready var player :Player= get_tree().get_first_node_in_group("Player")
@onready var diretor :Diretor= get_tree().get_first_node_in_group("Diretor")

@onready var mesh :RobotModel= $"robot-model"
@onready var nav_agent := $NavigationAgent3D

@onready var selecionado : bool = false
@onready var alvo : Vector3 = position

@export var velocidade := 3.0
#@export var inv_inicial := 0

func _ready():
	connect("escolhida", diretor._on_unidade_escolhida)
	connect("desescolhida", diretor._on_unidade_desescolhida)
	
	#$Inventario.quantidade = inv_inicial
	
	pointer_event.connect(_on_pointer_event)

	set_seleção(false)
	
	


#func _on_input_event(camera, event:InputEvent, event_position, normal, shape_idx):
	#if event.is_action_pressed("L_click"):
		#print(name, ' foi clicado')
		#set_seleção(!selecionado)
		#

func set_seleção(selec: bool):
	selecionado = selec
	mesh.mostrar_outline(selec)
	if selecionado:
		escolhida.emit(self)
	else: 
		desescolhida.emit(self)


func _on_diretor_mandar_ordem(posicao):
	if selecionado:
		set_alvo(posicao)
		print('andando de ', global_transform.origin, ' para ', alvo)
		print('vetor de mov ', (global_transform.origin - posicao).normalized() * velocidade)
		set_seleção(false)


func _physics_process(_delta):
	var pos_atual = global_transform.origin
	var pos_prox = alvo
	var vetor = (pos_prox - pos_atual).normalized() * velocidade
	nav_agent.velocity = vetor

func set_alvo(a : Vector3):
	alvo = a
	nav_agent.target_position = a

#movimento provisorio, dps mudar pra agentes e navmesh
func movimento_lerp(delta):
	if alvo.distance_to(position)>1:
		position = lerp(position, Vector3(alvo.x,position.y,alvo.z), 1*delta)
		


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	if alvo.distance_to(position)>1:
		look_at(Vector3(nav_agent.velocity.x+global_position.x ,position.y,nav_agent.velocity.z+global_position.z), Vector3.UP, true)
	move_and_slide()


func _on_navigation_agent_3d_target_reached():
	pass # Replace with function body.


#region sel: apontar pra selecionar

func _on_pointer_event(event):
	if event.event_type == event.Type.PRESSED:
		print("pointer event ", event)
		print(name, ' foi clicado pelo pointer VR!')
		set_seleção(!selecionado)

#endregion

#region mov: direcional direto

func _on_direcional_input(btnname:String, value:Vector2):
	#print("recebendo inputs...", btnname, value)
	if player.dir_apontando:
		var direct_alvo = global_position + Vector3(value.x, 0, -value.y).rotated(Vector3.UP, player.get_rot_mao_dir())*10000
		set_alvo(direct_alvo)
#endregion
