class_name valla extends Node3D
@export var player:Player
@export var show_distance := 100.0
@export var hide_distance := 102.0
@export var check_interval := 0.5

var visual_node: Node3D

var _is_visible := false

@export var max_distance:float = 1.0

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	visual_node = $Valla
	if visual_node:
		visual_node.visible = false
	start_distance_check()

func fade_in():
	pass

func fade_out():
	#print("borrado")
	queue_free()

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

	var dist_sq := global_position.distance_squared_to(player.global_position)

	if not _is_visible and dist_sq <= show_distance * show_distance:
		#print("se muestra ", dist_sq, " de ", show_distance*show_distance)
		_set_visible(true)
	elif _is_visible and dist_sq >= hide_distance * hide_distance:
		_set_visible(false)
		fade_out()
		#print("se oculta ", dist_sq)

func _set_visible(value: bool):
	_is_visible = value
	if visual_node:
		visual_node.visible = value

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.lostLife(1)
	pass # Replace with function body.
