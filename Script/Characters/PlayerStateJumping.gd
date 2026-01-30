extends StateBase

func on_process(delta: float) -> void:
	controlled_node.puntoMovil.progress += controlled_node.velocity_forward * delta
	if controlled_node.estaTocandoSuelo():
		controlled_node.animationPlayer.play("anim_jump")
		controlled_node.jump()
			#canJump = false
	if controlled_node.y_velocity < 0:
		state_machine.change_to("PlayerStateFalling")
