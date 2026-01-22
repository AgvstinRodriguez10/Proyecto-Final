extends MeshInstance3D
# Script que optimiza este MeshInstance3D
# usando VisibleOnScreenNotifier3D con AABB escalado
# El objeto se desactiva a los 5s de salir de cámara

@export var delay_off: float = 2.0  # segundos antes de desactivar

var notifier: VisibleOnScreenNotifier3D
var off_task: bool = false  # evita múltiples timers a la vez

func _ready() -> void:
	if mesh == null:
		return

	lod_bias = 0.8
	visibility_range_end = 300.0

	notifier = VisibleOnScreenNotifier3D.new()
	add_child(notifier)

	var aabb: AABB = mesh.get_aabb()
	aabb.position *= global_transform.basis.get_scale()
	aabb.size *= global_transform.basis.get_scale()
	notifier.aabb = aabb

	notifier.screen_entered.connect(_on_screen_entered)
	notifier.screen_exited.connect(_on_screen_exited)

	_set_active(true)

func _set_active(active: bool) -> void:
	visible = active
	set_process(active)
	set_physics_process(active)

func _on_screen_entered() -> void:
	off_task = false
	_set_active(true)
	print("Entró en cámara:", self.name)

func _on_screen_exited() -> void:
	if off_task:
		return
	off_task = true
	# Esperar X segundos antes de apagar
	await get_tree().create_timer(delay_off).timeout
	# Solo desactiva si sigue fuera de cámara
	if off_task and not notifier.is_on_screen():
		_set_active(false)
		print("Desapareció fuera de cámara:", self.name)
	off_task = false
