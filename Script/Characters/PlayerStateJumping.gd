extends PlayerStateBase

func on_process(delta: float) -> void:
	super(delta)
	#player.puntoMovil.progress += player.velocity_forward * delta
	if player.estaTocandoSuelo():
		player.animationPlayer.play(player.AnimStrings.jump)
		player.jump()
			#canJump = false
	if player.y_velocity < 0:
		state_machine.change_to(player.States.falling)
