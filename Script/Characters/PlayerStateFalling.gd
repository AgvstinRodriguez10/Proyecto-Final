extends PlayerStateBase


func on_process(delta: float) -> void:
	super(delta)
	#player.puntoMovil.progress += player.velocity_forward * delta
	if player.animationPlayer.current_animation != player.AnimStrings.fall:
		# si esta cayendo, y no fue de un salto, seteamos la animacion de salto para caer
		player.animationPlayer.play(player.AnimStrings.fall)
		
	if player.estaTocandoSuelo():
		state_machine.change_to(player.States.running)
