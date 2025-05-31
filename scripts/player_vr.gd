extends XROrigin3D

@export var initialize := false
@export var vrsim := false

var chamar_selecionados := false


func _ready():
	if !Engine.is_editor_hint() and initialize:
		$StartXR.initialize()
		var passthrough_on = enable_passthrough()
		print("passthrough rodando: ", passthrough_on)

func _process(_delta):
	mao_pra_cima()


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



func _on_mao_esq_button_pressed(name):
	
	#print('mao esquerda apertou: ', name)
	if name == 'grip_click' and chamar_selecionados:
		%diretor.emitir_ordem(self.position)

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
