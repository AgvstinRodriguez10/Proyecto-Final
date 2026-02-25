extends StateBase

var yagui: Yagui:
	set(value):
		controlled_node = value
	get:
		return controlled_node

func start():
	yagui.current_velocity_forward = yagui.velocity_forward
	
func on_process(delta):
	yagui.animationPlayer.play("anim_run")
	yagui.puntoMovil.progress += yagui.current_velocity_forward * delta
