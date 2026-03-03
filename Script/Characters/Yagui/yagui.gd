extends BasicCharacter
class_name Yagui

@export var puntoMovilPlayer: PathFollow3D
@export var player_ref: Player

func _ready() -> void:
	super._ready()
	animationPlayer = $Yagui1/AnimationPlayer
	#actualizarSpeed(1)
	velocity_forward = 20.05

#func actualizarSpeed(speed:float):
	#animationPlayer.speed_scale = speed * (current_velocity_forward * .005)
