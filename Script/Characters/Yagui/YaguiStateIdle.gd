extends StateBase

func start():
	controlled_node.current_velocity_forward = 0
	await get_tree().create_timer(0.1).timeout
	state_machine.change_to("YaguiStateRun")
