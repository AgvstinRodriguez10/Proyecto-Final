extends CanvasLayer

@onready var animationPlayer = $AnimationPlayer
@onready var LabelInicial = $"../Label"

func _ready() -> void:
	hide()

func _process(delta: float) -> void:
	if !LabelInicial.x == true:
		if Input.is_action_just_pressed("Escape") and get_tree().paused == false:
			get_tree().paused = true
			animationPlayer.play("animPause")
			LabelInicial.x = false
		elif Input.is_action_just_pressed("Escape") and get_tree().paused == true:
			get_tree().paused = false
			hide()
			LabelInicial.x = false


func _on_resume_pressed() -> void:
	get_tree().paused = false
	hide()
	
func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()
	#get_tree().change_scene_to_file() | World 
