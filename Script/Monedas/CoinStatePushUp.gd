extends CoinStateBase

@export var pull_up_distance := 3.0
@export var pull_up_speed := 2.0

var start_pos: Vector3
var target_pos: Vector3
var target: Player

func start():
	target = coin.player
	start_pos = coin.global_position
	target_pos = start_pos + Vector3.UP * pull_up_distance

func on_process(delta: float) -> void:
	coin.global_position = coin.global_position.lerp(
		target_pos,
		pull_up_speed * delta
	)

	# Cuando ya llegó arriba
	if coin.global_position.distance_to(target_pos) < 0.3:
		state_machine.change_to("CoinStatePushDown")
