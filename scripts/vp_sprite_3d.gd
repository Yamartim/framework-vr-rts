extends Sprite3D

@export var _vpt : ViewportTexture

# SERVE SÓ PRA NAO ACONTECER UM BUG DA ENGINE QUE DESCONECTA A VIEWPORT
func _ready() -> void:
	texture = _vpt
