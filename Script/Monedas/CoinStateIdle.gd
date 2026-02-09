extends CoinStateBase

#@export var pickup_distance := 2.0
@export var check_interval := 1.0
@export var velocity_rotate := 2.5

var _timer: Timer
var player

func start():
	player = coin.player
	coin.visible = true
	start_checks()

func end():
	if _timer:
		_timer.stop()
		_timer.queue_free()
		_timer = null

func on_process(delta: float) -> void:
	# Animamos la moneada para que rote
	coin.ModelAnimatable.rotate_y(delta * velocity_rotate)

func start_checks():
	if _timer:
		return
	
	_timer = Timer.new()
	_timer.wait_time = check_interval
	_timer.autostart = true
	_timer.one_shot = false
	add_child(_timer)
	_timer.timeout.connect(_check_logic)

func _check_logic():
	if not is_instance_valid(player):
		return

	var dist_sq := coin.global_position.distance_squared_to(player.global_position)

	# 1️⃣ Demasiado lejos → borrar
	if dist_sq >= get_show_distance_sq():
		coin.queue_free()


func _on_area_3d_body_entered(body: Player) -> void:
	if body == coin.player:
		state_machine.change_to("CoinStatePushUp")
