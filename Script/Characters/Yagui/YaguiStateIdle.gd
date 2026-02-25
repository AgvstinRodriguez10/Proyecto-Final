extends StateBase

func start():
	controlled_node.current_velocity_forward = 0

func on_process():
	if true:
		await get_tree().create_timer(2.0).timeout
		state_machine.change_to("YaguiStateRun")
