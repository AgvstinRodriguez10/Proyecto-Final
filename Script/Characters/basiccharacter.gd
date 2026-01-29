extends CharacterBody3D
class_name BasicCharacter

var animationPlayer: AnimationPlayer
var is_movie_idle : bool = false
var is_movie : bool = false
var velocity_forward:float = 0
var current_velocity_forward: float = 0
const JUMP_VELOCITY: float = 3.0  # Jump strength
var current_jump_velocity: float = 0

const GRAVITY: float = 5.4  # Gravity strength

enum STATES  {
	IDLE,
	RUN,
	JUMP,
	FALL,
	HIT
}
var eje_local_x:Vector3

var currentState:STATES = STATES.FALL

var rayCastSuelo := RayCast3D.new()

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

func animationController(delta):
	match currentState:
		STATES.IDLE:
			animationPlayer.play("anim_idle")
			stopMove()
			if !is_movie_idle:
				currentState = STATES.RUN
		STATES.RUN:
			animationPlayer.play("anim_run")
			if is_movie_idle:
				currentState = STATES.IDLE
			elif !estaTocandoSuelo():
				currentState = STATES.FALL

func movingToForward(delta: float):
	current_velocity_forward = velocity_forward

func gravityApply(delta: float):
	# ///GRAVEDAD/// #
	if not estaTocandoSuelo() and !is_movie_idle:
		# Si no esta tocando el suelo y no esta en idle, cae...
		#velocity.y -= GRAVITY * delta
		current_jump_velocity = lerpf(current_jump_velocity, 0, GRAVITY * delta)
		position.y = current_jump_velocity
		print("cae")
	else:
		current_jump_velocity = 0

func stopMove():
	current_velocity_forward = 0

func is_movie_change():
	is_movie = !is_movie

func actualizar_eje_local():
	eje_local_x = global_transform.basis.x.normalized()
	
func estaTocandoSuelo() -> bool:
	return rayCastSuelo.is_colliding()
