extends PlayerStateBase

func on_process(delta: float) -> void:
	super(delta)
	player.animationPlayer.play(player.AnimStrings.hitt)
	#player.lost_life()
	await player.animationPlayer.animation_finished
	if player.estaTocandoSuelo():
		state_machine.change_to(player.States.running)
	elif player.y_velocity < 0:
		state_machine.change_to(player.States.falling)
	player.is_hitt = false
