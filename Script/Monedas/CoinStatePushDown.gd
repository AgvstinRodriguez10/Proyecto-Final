extends CoinStateBase

@export var pull_in_speed := 4.0
@export var pickup_distance := 2.0
@export var max_distance := 10.0
@export var pickup_offset_y := 1.0 # 🔼 altura a la que va la moneda

var target: Player
var sound_played := false

func start():
	target = coin.player

	if coin.collision:
		coin.collision.disabled = true

func on_process(delta: float) -> void:
	if not is_instance_valid(target):
		coin.queue_free()
		return

	# Posición objetivo con offset
	var target_pos := target.global_position + Vector3.UP * pickup_offset_y

	var dist := coin.global_position.distance_to(target_pos)

	var t = clamp(dist / max_distance, 0.1, 1.0)
	var speed_factor = pull_in_speed * (1.0 / t)

	coin.global_position = coin.global_position.lerp(
		target_pos,
		speed_factor * delta
	)

	if not sound_played and coin.coinSound:
		coin.coinSound.play()
		sound_played = true

	if dist <= pickup_distance:
		_finalize_pickup()

func _finalize_pickup():
	coin.hide()
	target.get_coin(coin.coin_type)
	if coin.coinSound and coin.coinSound.playing:
		await coin.coinSound.finished

	coin.queue_free()
