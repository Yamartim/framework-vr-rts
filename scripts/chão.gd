extends XRToolsInteractableBody


func _on_pointer_event(event:XRToolsPointerEvent):
	if event.event_type == event.Type.PRESSED:
		if event.pointer.get_parent().name == 'Mao_Esq':
			%diretor.emit_signal("mandar_ordem", event.position)
		if event.pointer.get_parent().name == 'Mao_Dir':
			print('incrementando path')
			%Player.increment_path(event.position)
