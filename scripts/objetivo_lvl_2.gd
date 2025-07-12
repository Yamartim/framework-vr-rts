extends Node

signal terminar_level

@onready var level: Level = $".."

func _on_unidade_pegou_item() -> void:
	var estruturas = level._lvl_estruturas
	for estrutura in estruturas:
		var estrutura_c = estrutura.get_children()
		for child in estrutura_c:
			if child is Inventario:
				if len(child._itens) < 10:
					return
	terminar_level.emit()
