@tool
extends MultiMeshInstance3D

## Setear el padre de los markers a usar, recordar reiniciar la escena
@export var markers_parent: Node3D

## Activa esto para que se actualice la posicion con respecto a su marker
@export var refresh_editor:bool = false

var _last_count := -1

func _ready():
	setup_multimesh()

func _process(delta: float) -> void:
	# Esto es para que no se calcule el procces en ejecucion del juego.
	# solo sigue con su ejecucion si esta en el editor nomas
	if not Engine.is_editor_hint():
		return

	if refresh_editor:
		setup_multimesh()

func setup_multimesh():
	# este codigo se encarga de crear los faroles de cada marker
	if !markers_parent or not multimesh:
		return

	var markers := markers_parent.get_children()

	_last_count = markers.size()

	multimesh.instance_count = markers.size()

	for i in range(markers.size()):
		if markers[i] is Marker3D:
			multimesh.set_instance_transform(i, markers[i].global_transform)
