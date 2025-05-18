extends Node2D

func _ready():
	global.current_scene = "down_path"
	
func _process(delta):
	change_scene()

func _on_down_exit_point_body_entered(body: PhysicsBody2D):
	if body.name == "player 2":
		global.going_right = false
		global.going_left = false
		global.going_secret = false
		global.going_down = true
		global.transition_scene = true

func change_scene():
	if global.transition_scene == true:
		print("Current scene:", global.current_scene)
		print("going_down:", global.going_down)
		if global.current_scene == "down_path":
			get_tree().change_scene_to_file("res://SCENES/secret.tscn")
			global.finish_changescenes()
