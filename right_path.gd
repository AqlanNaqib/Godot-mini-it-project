extends Node2D

func _process(delta):
	change_scene()

func _on_rightpath_exit_point_body_entered(body: PhysicsBody2D):
	if body.name == "player 2":
		global.going_right = true
		global.going_left = false
		global.transition_scene = true
		
func change_scene():
	if global.transition_scene == true:
		print("attempting to change scene")
		if global.current_scene == "right_path":
			get_tree().change_scene_to_file("res://WORLD.tscn")
			global.finish_changescenes()
