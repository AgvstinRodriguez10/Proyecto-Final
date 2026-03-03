extends StateBase

var yagui: Yagui:
	set(value):
		controlled_node = value
	get:
		return controlled_node

func start():
	setVelocity()

func on_process(delta):
	yagui.animationPlayer.play("anim_run")
	yagui.puntoMovil.progress += yagui.current_velocity_forward * delta

func setVelocity():
	var flagToLostLife := false
	# Setea la velocidad segun la distancia al player, lo hace cada 2 segundos
	while !yagui.is_movie:
		var distanceToPlayer = yagui.puntoMovilPlayer.progress - yagui.puntoMovil.progress
		
		if distanceToPlayer < 2:
			yagui.current_velocity_forward = yagui.velocity_forward * 0.2
			if !flagToLostLife:
				#print("pierde vida")
				yagui.player_ref.lostLife(1)
				if yagui.player_ref.life <= 0:
					return
				flagToLostLife = true
		elif distanceToPlayer > 4 and distanceToPlayer < 10:
			yagui.current_velocity_forward = yagui.velocity_forward * 1.01
			if flagToLostLife:
				flagToLostLife = false
		elif distanceToPlayer > 10 and distanceToPlayer < 20:
			yagui.current_velocity_forward = yagui.velocity_forward * 1.2
		elif distanceToPlayer > 20 and distanceToPlayer < 100:
			yagui.current_velocity_forward = yagui.velocity_forward * 1.4
		
		await get_tree().create_timer(.5).timeout
