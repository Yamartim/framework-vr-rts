extends XRToolsInteractableBody


func _on_pointer_event(event:XRToolsPointerEvent):
	if event.event_type == event.Type.PRESSED:
		%diretor.emit_signal("mandar_ordem", event.position)
