extends CoinStateBase

#@export var show_distance := 100.0
@export var check_interval := 1.0

var player
var _timer: Timer

func start():
	player = coin.player
	coin.visible = false
	start_distance_check()

func end():
	if _timer:
		_timer.stop()
		_timer.queue_free()
		_timer = null

func start_distance_check():
	_timer = Timer.new()
	_timer.wait_time = check_interval
	_timer.one_shot = false
	_timer.autostart = true
	add_child(_timer)
	_timer.timeout.connect(_check_distance)

func _check_distance():
	if not is_instance_valid(player):
		return

	var dist_sq := coin.global_position.distance_squared_to(player.global_position)

	if dist_sq <= get_show_distance_sq():
		state_machine.change_to("CoinStateIdle")
