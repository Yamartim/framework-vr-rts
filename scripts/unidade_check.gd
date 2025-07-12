extends CheckButton
class_name UnidadeCheck

func _on_unidade_selecionada(_unidade):
	button_pressed = true
	
func _on_unidade_deselecionada(_unidade):
	button_pressed = false
	
