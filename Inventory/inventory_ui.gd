extends Control

var show = false

func _ready():
	close()

func _process(delta):
	if Input.is_action_just_pressed("i"):
		if show:
			close()
		else:
			open()
	

func close():
	visible = false
	show = false
	
func open():
	visible = true
	show = true
