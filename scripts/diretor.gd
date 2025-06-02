class_name Diretor extends Node

signal mandar_ordem

@onready var total_unidades = get_tree().get_nodes_in_group("Unidade")
@onready var controle_direto :XRController3D = %Player/Mao_Dir

var unidades_selecionadas = []

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_unidade_escolhida(unidade: Unidade):
	unidades_selecionadas.append(unidade)
	connect("mandar_ordem", unidade._on_diretor_mandar_ordem)
	controle_direto.connect("input_vector2_changed", unidade._on_direcional_input)

	#print(unidades_selecionadas)

func _on_unidade_desescolhida(unidade: Unidade):
	unidades_selecionadas.erase(unidade)
	
	if is_connected("mandar_ordem", unidade._on_diretor_mandar_ordem):
		disconnect("mandar_ordem", unidade._on_diretor_mandar_ordem)
	if controle_direto.is_connected("input_vector2_changed", unidade._on_direcional_input):
		controle_direto.disconnect("input_vector2_changed", unidade._on_direcional_input)

	#print(unidades_selecionadas)

func emitir_ordem(ponto:Vector3):
	mandar_ordem.emit(ponto)
