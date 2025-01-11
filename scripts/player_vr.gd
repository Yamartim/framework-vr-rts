extends XROrigin3D

@export var initialize :bool = false


func _ready():
	if !Engine.is_editor_hint() and initialize:
		$StartXR.initialize()
