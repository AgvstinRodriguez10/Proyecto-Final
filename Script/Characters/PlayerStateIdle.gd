extends PlayerStateBase

func on_process(delta:float) -> void:
	player.animationPlayer.play(player.AnimStrings.idle)
	player.stopMove()
	if !player.is_movie_idle:
		state_machine.change_to(player.States.running)
