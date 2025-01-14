extends XROrigin3D

@export var initialize := false
@export var vrsim := false

var chamar_selecionados := false


func _ready():
	if !Engine.is_editor_hint() and initialize:
		$StartXR.initialize()

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
