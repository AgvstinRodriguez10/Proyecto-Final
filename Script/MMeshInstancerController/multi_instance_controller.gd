@tool
extends MultiMeshInstance3D

## Setear el padre de los markers a usar, recordar reiniciar la escena
@export var markers_parent: Node3D

func _ready():
	setup_multimesh()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		setup_multimesh()

func setup_multimesh():
	if !markers_parent:
		return
	var markers := markers_parent.get_children()
	
	if not multimesh:
		return
	
	multimesh.instance_count = markers.size()

	for i in markers.size():
		multimesh.set_instance_transform(i, markers[i].global_transform)
