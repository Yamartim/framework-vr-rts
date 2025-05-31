extends Node

var states := {}
var current_state : State
@export var initial_state : State

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transicao.connect(on_transicao)
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)

# quando emitir o sinal transicao passa o proprio estado filbo que chamou e o nome do proximo estado
func on_transicao(state:State, new_state_name:String):
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		current_state.Exit()
	new_state.Enter() 
	
	current_state = new_state
