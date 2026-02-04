extends CoinStateBase

var player
@export var show_distance := 100.0
@export var hide_distance := 102.0
@export var check_interval := 1
var _is_visible := false

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	if coin.visible:
		coin.visible = false
	start_distance_check()

func start_distance_check():
	var timer := Timer.new()
	timer.wait_time = check_interval
	timer.one_shot = false
	timer.autostart = true
	add_child(timer)
	timer.timeout.connect(_update_visibility)

func _update_visibility():
	if not is_instance_valid(player):
		return

	var dist_sq := coin.global_position.distance_squared_to(player.global_position)

	if not _is_visible and dist_sq <= show_distance * show_distance:
		_set_visible(true)
		state_machine.change_to("CoinStateIdle")
	elif _is_visible and dist_sq >= hide_distance * hide_distance:
		_set_visible(false)

func _set_visible(value: bool):
	_is_visible = value
	if coin:
		coin.visible = value
