extends StateBase

var yagui: Yagui:
	set(value):
		controlled_node = value
	get:
		return controlled_node

var flagOnlyOneStart: bool = false

func start():
	if !flagOnlyOneStart:
		# Esto para que se inicie solo una vez
		hitting()
		flagOnlyOneStart = true

func end():
	flagOnlyOneStart = false

func on_process(delta):
	yagui.animationPlayer.play("anim_idle")
	yagui.puntoMovil.progress += yagui.current_velocity_forward * 0.2 * delta
	
	var distanceToPlayer = yagui.puntoMovilPlayer.progress - yagui.puntoMovil.progress
	if distanceToPlayer > 15:
		state_machine.change_to("YaguiStateRun")

func hitting():
	yagui.player_ref.lostLife(1)
	if yagui.player_ref.life <= 0:
		return
	
