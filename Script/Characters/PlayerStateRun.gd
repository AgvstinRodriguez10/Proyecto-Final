extends PlayerStateBase

func on_process(delta: float) -> void:
	super(delta)
	#player.puntoMovil.progress += player.velocity_forward * delta
	player.animationPlayer.play(player.AnimStrings.run)
	# Esto hace que si la camara se invierte, los controles laterales tambien, para tener el control de ambos casos de vision
	player.lateralController()
		
	if Input.is_key_label_pressed(KEY_M):
		#esto deberia cambiar una vez tengamos cuando se activa, llamando directamente a la funcion siguiente
		player.changeVisionCam()
	if player.is_movie_idle:
		state_machine.change_to(player.States.idle)
	elif player.y_velocity < 0:
		state_machine.change_to(player.States.falling)
		
func on_input():
	if Input.is_action_just_pressed("Saltar"):
		state_machine.change_to(player.States.jumping)
