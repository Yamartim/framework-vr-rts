extends Panel 
class_name MenuLevels

signal menu_mestre_button_down(num:int)
signal passtrough_button_down
signal scale_button_toggle(toggle:bool)

@onready var button_1: Button = $VBoxContainer/HBoxContainer/VBoxContainer/Button1
@onready var button_2: Button = $VBoxContainer/HBoxContainer/VBoxContainer2/Button2
@onready var button_3: Button = $VBoxContainer/HBoxContainer/VBoxContainer3/Button3
@onready var button_4: Button = $VBoxContainer/HBoxContainer/VBoxContainer4/Button4
@onready var button_5: Button = $VBoxContainer/HBoxContainer/VBoxContainer5/Button5

func _on_level_objetivo_cumprido(num:int):
	var button_to_update:Button
	match num:
		1:
			button_to_update = button_1
		2:
			button_to_update = button_2
		3:
			button_to_update = button_3
		4:
			button_to_update = button_4
		5:
			button_to_update = button_5
	
	button_to_update.add_theme_color_override("font_color", Color.CHARTREUSE)

func _on_button_1_button_down() -> void:
	menu_mestre_button_down.emit(1)


func _on_button_2_button_down() -> void:
	menu_mestre_button_down.emit(2)


func _on_button_3_button_down() -> void:
	menu_mestre_button_down.emit(3)


func _on_button_4_button_down() -> void:
	menu_mestre_button_down.emit(4)


func _on_button_5_button_down() -> void:
	menu_mestre_button_down.emit(5)


func _on_button_button_down() -> void:
	menu_mestre_button_down.emit(0)


func _on_button_passthrough_button_down() -> void:
	passtrough_button_down.emit()


func _on_scale_button_toggled(toggled_on: bool) -> void:
	scale_button_toggle.emit(toggled_on)
