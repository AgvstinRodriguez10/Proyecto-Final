class_name StateMachine extends Node

@onready var controlled_node: Node = self.owner

@export var default_state: StateBase

var current_state: StateBase = null

func _ready() -> void:
	call_deferred("_state_default_start")

func _state_default_start():
	current_state = default_state
	_state_start()

func _state_start():
	print("StateMachine ", controlled_node.name, " start state ", current_state)
	## Configuramos el estado
	current_state.controlled_node = controlled_node
	current_state.state_machine = self
	current_state.start()

func change_to(new_state:String):
	if current_state and current_state.has_method("end"): current_state.end()
	current_state = get_node(new_state)
	_state_start()

func _process(delta: float) -> void:
	if current_state and current_state.has_method("on_process"):
		current_state.on_process(delta)

func _input(event: InputEvent) -> void:
	if current_state and current_state.has_method("on_input"):
		current_state.on_input()
