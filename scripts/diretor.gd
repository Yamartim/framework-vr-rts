class_name Diretor extends Node

signal mandar_ordem
signal mandar_caminho(curve:Curve3D)

@export var _level_list : Array[PackedScene]

@onready var _total_unidades : Array
@onready var _controle_direto_sig :Signal = %Player/Mao_Dir.input_vector2_changed

@onready var _active_levels :Node= %levels

@onready var _menu: XRToolsViewport2DIn3D = %menu

var _unidades_selecionadas = []

func _on_unidade_escolhida(unidade: Unidade):
	_unidades_selecionadas.append(unidade)
	
	mandar_ordem.connect(unidade._on_diretor_mandar_ordem)
	mandar_caminho.connect(unidade._on_player_send_path)
	_controle_direto_sig.connect(unidade._on_direcional_input)

	#print(_unidades_selecionadas)

func _on_unidade_desescolhida(unidade: Unidade):
	_unidades_selecionadas.erase(unidade)
	
	if mandar_ordem.is_connected(unidade._on_diretor_mandar_ordem):
		mandar_ordem.disconnect(unidade._on_diretor_mandar_ordem)
	if mandar_caminho.is_connected(unidade._on_player_send_path):
		mandar_caminho.disconnect(unidade._on_player_send_path)
	if _controle_direto_sig.is_connected(unidade._on_direcional_input):
		_controle_direto_sig.disconnect(unidade._on_direcional_input)

	#print(_unidades_selecionadas)

func emitir_ordem(ponto:Vector3):
	mandar_ordem.emit(ponto)
	
func emitir_caminho(curve:Curve3D):
	mandar_caminho.emit(curve)

func _on_trocar_level(num: int):

	var ui_menu : MenuLevels = _menu.get_scene_instance()

	for level in _active_levels.get_children():
		if level:
			if level.is_connected('objetivo_cumprido', ui_menu._on_level_objetivo_cumprido):
				level.disconnect('objetivo_cumprido',ui_menu._on_level_objetivo_cumprido)
		level.queue_free()
		
	var level_to_load :Level= null

	match num:
		0:
			get_tree().reload_current_scene()
			return
		1:
			level_to_load = _level_list[0].instantiate()
		2:
			level_to_load = _level_list[1].instantiate()
		3:
			level_to_load = _level_list[2].instantiate()
		4:
			level_to_load = _level_list[3].instantiate()
		5:
			level_to_load = _level_list[4].instantiate()
	
	if level_to_load != null:
		_active_levels.add_child(level_to_load)
		level_to_load.objetivo_cumprido.connect(ui_menu._on_level_objetivo_cumprido)
		update_lista_unidades()
		$"../NavigationRegion3D".bake_navigation_mesh()
		print('trocando para level...', num)
		return
	push_error("troca de level falhou")

func update_lista_unidades():
	_total_unidades = get_tree().get_nodes_in_group("Unidade")
	%Player.update_mao_ui(_total_unidades)

func switch_world_scale(toggle:bool):
	if toggle:
		_menu.scale = Vector3(10,10,10)
		%Player.world_scale = 10
	else:
		_menu.scale = Vector3(1,1,1)
		%Player.world_scale = 1
