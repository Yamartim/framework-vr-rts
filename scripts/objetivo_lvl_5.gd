extends Node

signal terminar_level

@onready var level: Level = $".."
@onready var objetivo: Area3D = $"../objetivo"


func _on_objetivo_body_entered(body: Node3D) -> void:
	for unidade in level._lvl_unidades:
		if !objetivo.overlaps_body(unidade):
			return
	terminar_level.emit()
