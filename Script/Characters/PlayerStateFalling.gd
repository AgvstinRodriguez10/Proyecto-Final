extends StateBase


func on_process(delta: float) -> void:
	controlled_node.puntoMovil.progress += controlled_node.velocity_forward * delta
	if controlled_node.animationPlayer.current_animation != "anim_jump":
		# si esta cayendo, y no fue de un salto, seteamos la animacion de salto para caer
		controlled_node.animationPlayer.play("anim_jump")
		
	if controlled_node.estaTocandoSuelo():
		state_machine.change_to("PlayerStateRun")
