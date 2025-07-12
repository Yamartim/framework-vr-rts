extends Node

@onready var _menu: XRToolsViewport2DIn3D = %menu

# SERVE SÓ PRA CONECTAR A CENA DA UI COM O DIRETOR
func _ready() -> void:
	var diretor: Diretor= %diretor
	var player: Player = %Player

	var ui_menu : MenuLevels = _menu.get_scene_instance()
	ui_menu.menu_mestre_button_down.connect(diretor._on_trocar_level)
	ui_menu.passtrough_button_down.connect(player.enable_passthrough.bind(!player._passthrough_on))
	ui_menu.scale_button_toggle.connect(diretor.switch_world_scale)
