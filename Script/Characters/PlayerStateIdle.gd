extends StateBase

func on_process(delta:float) -> void:
	#animationPlayer.play("anim_idle")
	controlled_node.animationPlayer.play("anim_idle")
	controlled_node.stopMove()
	if !controlled_node.is_movie_idle:
		state_machine.change_to("PlayerStateRun")
