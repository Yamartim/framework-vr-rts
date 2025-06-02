extends XROrigin3D

@export var initialize := false
@export var vrsim := false

@onready var cone_selecao: MeshInstance3D = $Mao_Esq/cone_selecao
@onready var cone_deselecao: MeshInstance3D = $Mao_Esq/cone_deselecao

@onready var function_pointer: XRToolsFunctionPointer = $Mao_Esq/FunctionPointer

var chamar_selecionados := false
var cone_selecao_on := false
var cone_deselecao_on := false

func _ready():
	if !Engine.is_editor_hint() and initialize:
		$StartXR.initialize()
		var passthrough_on = enable_passthrough()
		print("passthrough rodando: ", passthrough_on)
		
	cone_selecao.visible = false
	cone_deselecao.visible = false

func _process(_delta):
	mao_pra_cima()
	check_cones()

func enable_passthrough() -> bool:
	var xr_interface: XRInterface = XRServer.primary_interface
	if xr_interface and xr_interface.is_passthrough_supported():
		if !xr_interface.start_passthrough():
			return false
	else:
		var modes = xr_interface.get_supported_environment_blend_modes()
		if xr_interface.XR_ENV_BLEND_MODE_ALPHA_BLEND in modes:
			xr_interface.set_environment_blend_mode(xr_interface.XR_ENV_BLEND_MODE_ALPHA_BLEND)
		else:
			return false
	
	get_viewport().transparent_bg = true
	return true

func _on_function_pointer_pointing_event(_event : XRToolsPointerEvent):
	#print(event.target.name)
	pass

func mao_pra_cima():
	var maocima = $Mao_Esq.global_rotation_degrees.x > 70
	
	chamar_selecionados = maocima
	if maocima:
		$Mao_Esq/LeftHand.hand_material_override.albedo_color = Color.REBECCA_PURPLE
	else:
		$Mao_Esq/LeftHand.hand_material_override.albedo_color = Color.YELLOW

func check_cones():
	if cone_selecao_on:
		var cast = cone_selecao.get_child(0).collision_result
		#print(cast)
		for body in cast:
			if body["collider"] is Unidade:
				body["collider"].set_seleção(true)
	if cone_deselecao_on:
		var cast = cone_deselecao.get_child(0).collision_result
		#print(cast)
		for body in cast:
			if body["collider"] is Unidade:
				body["collider"].set_seleção(false)

func _on_mao_esq_button_pressed(btnname):
	print('mao esquerda apertou: ', btnname)
	
	if btnname == 'grip_click' and chamar_selecionados:
		%diretor.emitir_ordem(self.position)

	elif btnname == 'ax_button':
		print("ativando SEL")
		cone_selecao_on = true
		cone_selecao.visible = true
		
		cone_deselecao_on = false
		cone_deselecao.visible = false
		
		function_pointer.set_enabled(false)

	elif btnname == 'by_button':
		print("ativando DESEL")
		cone_selecao_on = false
		cone_selecao.visible = false
		
		cone_deselecao_on = true
		cone_deselecao.visible = true
		
		function_pointer.set_enabled(false)


func _on_mao_esq_button_released(btnname: String) -> void:
	print('solto...', btnname)
	
	if btnname == 'ax_button':
		cone_selecao_on = false
		cone_selecao.visible = false
		if not cone_deselecao_on:
			function_pointer.set_enabled(true)
		
	elif btnname == 'by_button':
		cone_deselecao_on = false
		cone_deselecao.visible = false
		if not cone_selecao_on:
			function_pointer.set_enabled(true)


func _on_selecao_body_entered(body: Node3D) -> void:
	if body is Unidade:
		body.set_seleção(true)


func _on_deselecao_body_entered(body: Node3D) -> void:
	if body is Unidade:
		body.set_seleção(false)
