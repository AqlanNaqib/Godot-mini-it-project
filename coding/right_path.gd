extends Node2D

func _process(delta):
	change_scene()

func _on_rightpath_exit_point_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		global.going_right = true
		global.going_left = false
		global.going_down = false
		global.going_secret = false
		global.transition_scene = true
		
func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "right_path":
			get_tree().change_scene_to_file("res://SCENES/WORLD_REAL.tscn")
			global.finish_changescenes()
