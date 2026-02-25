extends CharacterBody3D
class_name BasicCharacter

var animationPlayer: AnimationPlayer
var is_movie_idle : bool = false
var is_movie : bool = false
var velocity_forward:float = 0
var current_velocity_forward: float = 0
const jump_force: float = 10.5  # Jump strength
var y_velocity: float = 0

const gravity: float = 23.0  # Gravity strength

var eje_local_x:Vector3

var rayCastSuelo := RayCast3D.new()

var puntoMovil:PathFollow3D

func _ready() -> void:
	position = position
	eje_local_x = global_transform.basis.x.normalized()
	
	# Agregamos el raycast por codigo
	rayCastSuelo.name = "RayoAlSuelo"
	rayCastSuelo.position = Vector3(0, 1, 0)
	rayCastSuelo.target_position = Vector3(0, -1.0, 0)
	rayCastSuelo.add_exception(self)
	rayCastSuelo.enabled = true
	add_child(rayCastSuelo)
	
	# Variable que contiene al punto que se mueve en el Path
	puntoMovil = $".."

#func movingToForward(delta: float):
	#current_velocity_forward = velocity_forward

func jump():
	y_velocity = jump_force

func gravityApply(delta: float):
	# Aplicar gravedad
	y_velocity -= gravity * delta
	# Mover en Y
	position.y += y_velocity * delta
	# Piso con RayCast
	if estaTocandoSuelo() and y_velocity < 0:
		position.y = 0
		y_velocity = 0

func stopMove():
	current_velocity_forward = 0

func is_movie_change():
	is_movie = !is_movie

func estaTocandoSuelo() -> bool:
	return rayCastSuelo.is_colliding()
