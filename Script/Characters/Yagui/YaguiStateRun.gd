extends StateBase

var yagui: Yagui:
	set(value):
		controlled_node = value
	get:
		return controlled_node

var flagKillCorutine: bool = false

var index: int = 0

func start():
	setVelocity()

func end():
	flagKillCorutine = false

func on_process(delta):
	yagui.animationPlayer.play("anim_run")
	yagui.puntoMovil.progress += yagui.current_velocity_forward * delta

func setVelocity():
	# Setea la velocidad segun la distancia al player, lo hace cada 2 segundos
	while !yagui.is_movie:
		var distanceToPlayer = yagui.puntoMovilPlayer.progress - yagui.puntoMovil.progress
		
		if distanceToPlayer < 2:
			state_machine.change_to("YaguiStateHit")
			flagKillCorutine = true
			break
		elif distanceToPlayer > 4 and distanceToPlayer < 15:
			yagui.current_velocity_forward = yagui.velocity_forward * 1.02
			print("va en primera")
		elif distanceToPlayer > 15 and distanceToPlayer < 25:
			yagui.current_velocity_forward = yagui.velocity_forward * 1.3
			print("va en 2da")
		elif distanceToPlayer > 25 and distanceToPlayer < 100:
			yagui.current_velocity_forward = yagui.velocity_forward * 1.7
			print("va en 3ra")
		await get_tree().create_timer(.5).timeout
