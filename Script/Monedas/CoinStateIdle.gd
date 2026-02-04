extends CoinStateBase

var posInitial: Vector3
var idleDistUp = .8
var targetHeight


enum ANIM_STATE {
	IDLE_DOWN,
	IDLE_UP
}
var currentAnimState := ANIM_STATE.IDLE_UP

func _ready() -> void:
	posInitial = coin.ModelAnimatable.position
	targetHeight = posInitial.y + idleDistUp

func on_process(delta: float) -> void:
	match currentAnimState:
		ANIM_STATE.IDLE_UP:
			animationCoinsUp(delta)
			animRotator(delta)
		ANIM_STATE.IDLE_DOWN:
			animationCoinsDown(delta)
			animRotator(delta)

func animationCoinsUp(delta:float):
	#definido en el ready:
	#targetHeight = posInitial.y + idleDistUp
	if(coin.ModelAnimatable.position.y < targetHeight - 0.1):
		coin.ModelAnimatable.position.y = lerpf(coin.ModelAnimatable.position.y, targetHeight, delta * 2.2)
	else:
		currentAnimState = ANIM_STATE.IDLE_DOWN

func animationCoinsDown(delta:float):
	if(coin.ModelAnimatable.position.y > posInitial.y + 0.05):
		coin.ModelAnimatable.position.y = lerpf(coin.ModelAnimatable.position.y, posInitial.y, delta * 2)
	else:
		currentAnimState = ANIM_STATE.IDLE_UP

func animRotator(delta:float):
	coin.ModelAnimatable.rotate_y(lerp(0, 2, delta * 2))
