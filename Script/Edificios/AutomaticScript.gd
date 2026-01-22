extends Node3D
# Script que va en Derecha para asignar automáticamente el optimizador a cada Edificio-*

const EdificioOptimizer = preload("res://Script/Edificios/Optimization.gd")


func _ready() -> void:
	for child in get_children():
		if child is Node3D:
			if child.get_script() == null:
				child.set_script(EdificioOptimizer)
				child.call_deferred("_ready")  # fuerza inicialización
