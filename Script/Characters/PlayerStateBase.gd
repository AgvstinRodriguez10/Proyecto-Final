class_name PlayerStateBase extends StateBase

var player: Player:
	set(value):
		controlled_node = value
	get:
		return controlled_node

func on_process(delta: float) -> void:
	player.puntoMovil.progress += player.velocity_forward * delta
