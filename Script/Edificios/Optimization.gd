extends Node3D
# Script para optimizar un MeshInstance3D hijo llamado "Plane"
# usando VisibleOnScreenNotifier3D y Obteniendo el AABB
# Los objetos se desactivan al pasar 15 segundos sin camara

@export var lod_bias: float = 0.5
@export var visibility_range: float = 300
@export var delay_off: float = 20 # segundos antes de desactivar

@onready var mesh: MeshInstance3D = $Plane
var notifier: VisibleOnScreenNotifier3D = null
var off_task: bool = false  # para evitar que se lance múltiples veces

func _ready() -> void:
	
	if mesh == null or mesh.mesh == null:
		return
	
# Optimiza LOD , VisibilityRange , Luz en modo Estatico, Baja la escala del Ligthmap
	#mesh.GIMode.GI_MODE_STATIC  # Actualmente, no se usa.
	#mesh.gi_lightmap_texel_scale = 0.2 # Actualmente, no se usa.
	mesh.lod_bias = lod_bias
	mesh.visibility_range_end = visibility_range

	notifier = VisibleOnScreenNotifier3D.new()
	add_child(notifier)

	var aabb = mesh.get_aabb()   # Obtiene el AABB
	aabb.size *= mesh.scale      # Obtiene el tamaño exacto del AABB.
	aabb.position *= mesh.scale
	notifier.aabb = aabb         # El AABB Otenido se lo mandamos al Notifier

	#Conectamos las señales.
	notifier.connect("screen_entered", Callable(self, "_on_screen_entered"))  
	notifier.connect("screen_exited", Callable(self, "_on_screen_exited"))  

	_set_mesh_active(false)

func _set_mesh_active(active: bool) -> void:
	if mesh:
		mesh.visible = active
		mesh.set_process(active)

func _on_screen_entered() -> void:
	off_task = false  # cancelamos cualquier espera pendiente
	_set_mesh_active(true)

func _on_screen_exited() -> void:
	if off_task:
		return
	off_task = true
	# Esperar delay_off segundos antes de desactivar
	await get_tree().create_timer(delay_off).timeout
	if off_task:  # si no se volvió a activar
		_set_mesh_active(false)
		off_task = false
