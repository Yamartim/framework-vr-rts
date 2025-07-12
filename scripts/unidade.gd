class_name Unidade extends CharacterBody3D

signal escolhida(unidade:Unidade)
signal desescolhida(unidade:Unidade)
signal pegou_item
signal deixou_item

#PRECISA ter um sinal com esse nome pro pointer event emitir
signal pointer_event(event:XRToolsPointerEvent)

@onready var _player :Player= get_tree().get_first_node_in_group("Player")
@onready var _diretor :Diretor= get_tree().get_first_node_in_group("Diretor")

@onready var _model :RobotModel= $"robot-model"
@onready var _nav_agent := $NavigationAgent3D
@onready var _inventario: Inventario = $Inventario
@onready var path_3d: Path3D = $Path3D
@onready var path_follow_3d: PathFollow3D = $Path3D/PathFollow3D
var _seguindo_path:= false


@onready var _selecionado : bool = false
@onready var _alvo : Vector3

@export var _velocidade := 3.0
#@export var inv_inicial := 0

func _ready():
	escolhida.connect(_diretor._on_unidade_escolhida)
	desescolhida.connect(_diretor._on_unidade_desescolhida)
	
	#$Inventario.quantidade = inv_inicial
	
	pointer_event.connect(_on_pointer_event)
	_model.anim_idle()
	
	set_seleção(false)

# input de mouse
#func _on_input_event(camera, event:InputEvent, event_position, normal, shape_idx):
	#if event.is_action_pressed("L_click"):
		#print(name, ' foi clicado')
		#set_seleção(!selecionado)
		#

func set_seleção(selec: bool):
	_selecionado = selec
	_model.mostrar_outline(selec)
	if _selecionado:
		escolhida.emit(self)
	else: 
		desescolhida.emit(self)


func _on_diretor_mandar_ordem(posicao):
	if _selecionado:
		set_alvo(posicao)
		print('andando de ', global_transform.origin, ' para ', _alvo)
		print('vetor de mov ', (global_transform.origin - posicao).normalized() * _velocidade)
		set_seleção(false)

func _on_player_send_path(curve:Curve3D):
	if !_seguindo_path:
		path_3d.curve = curve
		set_seleção(false)
		_seguindo_path = true
	

func _physics_process(_delta):
	var pos_atual = global_transform.origin
	var pos_prox = _alvo
	var vetor = (pos_prox - pos_atual).normalized() * _velocidade
	_nav_agent.velocity = vetor
	logica_path()

func set_alvo(a : Vector3):
	_alvo = a
	_nav_agent.target_position = a
	_model.anim_walk()

func logica_path():
	if _seguindo_path and path_follow_3d.progress_ratio < 0.95:
		path_follow_3d.progress += _velocidade
		set_alvo(path_follow_3d.position)
	elif path_follow_3d.progress_ratio >= 0.95:
		path_3d.curve.clear_points()
		_seguindo_path = false
		_model.anim_idle()

#movimento provisorio, dps mudar pra agentes e navmesh
func movimento_lerp(delta):
	if _alvo.distance_to(position)>1:
		position = lerp(position, Vector3(_alvo.x,position.y,_alvo.z), 1*delta)
		


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	if _alvo.distance_to(position)>1:
		look_at(Vector3(_nav_agent.velocity.x+global_position.x ,position.y,_nav_agent.velocity.z+global_position.z), Vector3.UP, true)
	move_and_slide()



func _on_navigation_agent_3d_target_reached():
	_model.anim_idle()

#region sel: apontar pra selecionar

func _on_pointer_event(event):
	if event.event_type == event.Type.PRESSED:
		print("pointer event ", event)
		print(name, ' foi clicado pelo pointer VR!')
		set_seleção(!_selecionado)

#endregion

#region mov: direcional direto

func _on_direcional_input(btnname:String, value:Vector2):
	#print("recebendo inputs...", btnname, value)
	if _player._dir_apontando:
		var direct_alvo = global_position + Vector3(value.x, 0, -value.y).rotated(Vector3.UP, _player.get_rot_mao_dir())*10000
		set_alvo(direct_alvo)
		_model.anim_walk()

#endregion


func _on_area_pega_item_body_entered(body: Node3D) -> void:
	print('obj in range: ', body.name)
	
	if body is XRToolsPickable and body.get_parent() is not Inventario:
		print("unidade achou item solto")
		body.global_position = _inventario.global_position
		_inventario.adicionar_item(body)
		body.position = Vector3.ZERO
		pegou_item.emit()
		
	if body.is_in_group('Estrutura'):
		print('achou estrutura')
		var inv :Inventario= body.find_child('Inventario')
		if len(_inventario._itens) > 0:
			set_alvo(body.position)
			await get_tree().create_timer(2).timeout
			_inventario.transferir_item(inv)
			_model.anim_interact()
			deixou_item.emit()

	if body.is_in_group('Recurso'):
		print('achou recurso')
		var inv :Inventario= body.find_child('Inventario')
		if len(inv._itens) > 0:
			set_alvo(body.position)
			await get_tree().create_timer(2).timeout
			inv.transferir_item(_inventario)
			_model.anim_interact()
			pegou_item.emit()
