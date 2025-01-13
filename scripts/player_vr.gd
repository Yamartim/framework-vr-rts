extends XROrigin3D

@export var initialize := false
@export var vrsim := false



func _ready():
	if !Engine.is_editor_hint() and initialize:
		$StartXR.initialize()


func _on_function_pointer_pointing_event(event : XRToolsPointerEvent):
	#print(event.target.name)
	pass
