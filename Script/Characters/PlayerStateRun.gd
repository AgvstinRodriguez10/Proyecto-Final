extends StateBase

func on_process(delta: float) -> void:
	controlled_node.puntoMovil.progress += controlled_node.velocity_forward * delta
	controlled_node.animationPlayer.play("anim_run")
	# Esto hace que si la camara se invierte, los controles laterales tambien, para tener el control de ambos casos de vision
	controlled_node.lateralController()
		
	if Input.is_key_label_pressed(KEY_M):
		#esto deberia cambiar una vez tengamos cuando se activa, llamando directamente a la funcion siguiente
		controlled_node.changeVisionCam()
	if controlled_node.is_movie_idle:
		state_machine.change_to("PlayerStateIdle")
	#elif !controlled_node.estaTocandoSuelo():
		#currentState = STATES.FALL
func on_input():
	if Input.is_action_just_pressed("Saltar"):
		state_machine.change_to("PlayerStateJumping")
