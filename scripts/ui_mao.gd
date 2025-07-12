extends Panel
class_name UIMao

@export var _unidade_check_btn : PackedScene

@onready var _unidades_container: GridContainer = $HBoxContainer

func clear_container():
	var checks = _unidades_container.get_children()
	for check in checks:
		check.queue_free()
		
func add_check(unidade: Unidade):
	var novo_check : UnidadeCheck = _unidade_check_btn.instantiate()
	novo_check.button_pressed = unidade._selecionado
	novo_check.toggled.connect(unidade.set_seleção)
	novo_check.text = unidade.name
	unidade.escolhida.connect(novo_check._on_unidade_selecionada)
	unidade.desescolhida.connect(novo_check._on_unidade_deselecionada)
	_unidades_container.add_child(novo_check)
