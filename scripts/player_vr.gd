class_name Player
extends XROrigin3D

@export var _initialize_passthrough := false
@export var _vrsim := false

@onready var _diretor :Diretor= %diretor

@onready var _cone_selecao: MeshInstance3D = $Mao_Esq/cone_selecao
@onready var _cone_deselecao: MeshInstance3D = $Mao_Esq/cone_deselecao

@onready var _function_pointer: XRToolsFunctionPointer = $Mao_Esq/FunctionPointer

@onready var path_3d: Path3D = $Path3D


var _chamar_selecionados := false
var _cone_selecao_on := false
var _cone_deselecao_on := false
var _seguindo_path := false

var _dir_apontando := false
var _menu_mao := false
var _path_draw := false

var _passthrough_on:bool

func _ready():
	if _initialize_passthrough:
		_passthrough_on = enable_passthrough(true)
		print("passthrough rodando: ", _passthrough_on)
		
	_cone_selecao.visible = false
	_cone_deselecao.visible = false

func _process(_delta):
	mao_pra_cima()
	check_cones()

func enable_passthrough(toggle:bool) -> bool:
	var xr_interface: XRInterface = XRServer.primary_interface
	if toggle:
		
		if xr_interface and xr_interface.is_passthrough_supported():
			if !xr_interface.start_passthrough():
				return false
		elif !_vrsim:
			var modes = xr_interface.get_supported_environment_blend_modes()
			if xr_interface.XR_ENV_BLEND_MODE_ALPHA_BLEND in modes:
				xr_interface.set_environment_blend_mode(xr_interface.XR_ENV_BLEND_MODE_ALPHA_BLEND)
			else:
				return false
		get_viewport().transparent_bg = true
		return true

	else: 
		xr_interface.stop_passthrough()
		get_viewport().transparent_bg = false
		_passthrough_on = false
		return false
	

func _on_function_pointer_pointing_event(_event : XRToolsPointerEvent):
	#print(event.target.name)
	pass

func mao_pra_cima():
	var maocima = $Mao_Esq.global_rotation_degrees.x > 70
	
	_chamar_selecionados = maocima
	if maocima:
		mao_esq_mudar_cor(Color.REBECCA_PURPLE)
	else:
		mao_esq_mudar_cor(Color.YELLOW)

func get_rot_mao_dir()->float: return $Mao_Dir.global_rotation.y

#region sel: cones de selecao

func check_cones():
	if _cone_selecao_on:
		var cast = _cone_selecao.get_child(0).collision_result
		#print(cast)
		for body in cast:
			if body["collider"] is Unidade:
				body["collider"].set_seleção(true)
	if _cone_deselecao_on:
		var cast = _cone_deselecao.get_child(0).collision_result
		#print(cast)
		for body in cast:
			if body["collider"] is Unidade:
				body["collider"].set_seleção(false)


func _on_mao_esq_button_pressed(btnname):
	print('mao esquerda apertou: ', btnname)
	
	if btnname == 'grip_click' and _chamar_selecionados:
		_diretor.emitir_ordem(self.position)

	elif btnname == 'ax_button':
		print("ativando SEL")
		_cone_selecao_on = true
		_cone_selecao.visible = true
		
		_cone_deselecao_on = false
		_cone_deselecao.visible = false
		
		_function_pointer.show_laser = XRToolsFunctionPointer.LaserShow.HIDE
		_function_pointer.set_enabled(false)
		mao_esq_mudar_cor(Color.BLUE)

	elif btnname == 'by_button':
		print("ativando DESEL")
		_cone_selecao_on = false
		_cone_selecao.visible = false
		
		_cone_deselecao_on = true
		_cone_deselecao.visible = true
		
		_function_pointer.show_laser = XRToolsFunctionPointer.LaserShow.HIDE
		_function_pointer.set_enabled(false)
		mao_esq_mudar_cor(Color.BLUE)


func _on_mao_esq_button_released(btnname: String) -> void:
	print('solto...', btnname)
	
	if btnname == 'ax_button':
		_cone_selecao_on = false
		_cone_selecao.visible = false
		if not _cone_deselecao_on:
			_function_pointer.show_laser = XRToolsFunctionPointer.LaserShow.SHOW
			_function_pointer.set_enabled(true)
			mao_esq_mudar_cor(Color.YELLOW)
		
	elif btnname == 'by_button':
		_cone_deselecao_on = false
		_cone_deselecao.visible = false
		if not _cone_selecao_on:
			_function_pointer.show_laser = XRToolsFunctionPointer.LaserShow.SHOW
			_function_pointer.set_enabled(true)
			mao_esq_mudar_cor(Color.YELLOW)


func _on_selecao_body_entered(body: Node3D) -> void:
	if body is Unidade:
		body.set_seleção(true)


func _on_deselecao_body_entered(body: Node3D) -> void:
	if body is Unidade:
		body.set_seleção(false)
#endregion

#region mov: apontar pra mover

func _on_mao_dir_button_pressed(btnname: String) -> void:
	
	var modo_pathdraw :bool= btnname == 'by_button'
	var modo_maoui :bool= btnname == 'ax_button'
	var modo_movdireto :bool= btnname == 'grip_click'
	
	var mao_dir_paralel_chao :bool= abs($Mao_Dir.global_rotation_degrees.x) < 50
	var unidades_sel = !_diretor._unidades_selecionadas.is_empty()
	var cond_apontar_mov_direto: bool= modo_movdireto and unidades_sel and mao_dir_paralel_chao
	if cond_apontar_mov_direto and not (_path_draw or _menu_mao):
		_dir_apontando = true
		$Mao_Dir/MovementTurn.enabled = false
		mao_dir_mudar_cor(Color.WEB_GREEN)
	
	elif modo_pathdraw and not (_dir_apontando or _menu_mao):
		_path_draw = true
		reset_path()
		$Mao_Dir/PathPointer.enabled = true
		$Mao_Dir/PathPointer.visible = true
		mao_dir_mudar_cor(Color.ORANGE)

	elif modo_maoui and not (_path_draw or _dir_apontando):
		_menu_mao = true
		%diretor.update_lista_unidades()
		$Mao_Dir/MenuMao.enabled = true
		$Mao_Dir/MenuMao.visible = true
		mao_dir_mudar_cor(Color.SLATE_GRAY)



func _on_mao_dir_button_released(btnname: String) -> void:
	
	var modo_pathdraw :bool= btnname == 'by_button'
	var modo_maoui :bool= btnname == 'ax_button'
	var modo_movdireto :bool= btnname == 'grip_click'

	if modo_movdireto and _dir_apontando:
		_dir_apontando = false
		$Mao_Dir/MovementTurn.enabled = true
		mao_dir_mudar_cor(Color.YELLOW)

	elif modo_pathdraw and _path_draw:
		_path_draw = false
		$Mao_Dir/PathPointer.enabled = false
		$Mao_Dir/PathPointer.visible = false
		if !_diretor._unidades_selecionadas.is_empty() and path_3d.curve.point_count > 1:
			_diretor.emitir_caminho(path_3d.curve)
		mao_dir_mudar_cor(Color.YELLOW)

	elif modo_maoui and _menu_mao:
		_menu_mao = false
		$Mao_Dir/MenuMao.enabled = false
		$Mao_Dir/MenuMao.visible = false
		mao_dir_mudar_cor(Color.YELLOW)
		
#endregion

func reset_path():
	path_3d.curve.clear_points()
	path_3d.curve.add_point(Vector3.ZERO)

func increment_path(novo_ponto:Vector3):
	path_3d.curve.add_point(novo_ponto)

func mao_esq_mudar_cor(cor:Color):
	$Mao_Esq/LeftHand.hand_material_override.albedo_color = cor
	
func mao_dir_mudar_cor(cor:Color):
	$Mao_Dir/RightHand.hand_material_override.albedo_color = cor

func update_mao_ui(unidades : Array):
	var menu_unidades :UIMao = $Mao_Dir/MenuMao.get_scene_instance()
	if menu_unidades:
		print('update mao ui')
		menu_unidades.clear_container()
		for unidade in unidades:
			menu_unidades.add_check(unidade)
