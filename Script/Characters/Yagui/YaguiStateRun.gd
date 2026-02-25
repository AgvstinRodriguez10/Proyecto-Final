extends StateBase

var yagui: Yagui:
	set(value):
		controlled_node = value
	get:
		return controlled_node

func start():
	yagui.current_velocity_forward = yagui.velocity_forward
	yagui.animationPlayer.play("anim_run")

func on_procces(delta):
	yagui.puntoMovil.progress += yagui.current_velocity_forward * delta
