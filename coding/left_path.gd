extends Node2D


func _process(delta):
	change_scene()


func _on_leftpath_exit_point_body_entered(body: PhysicsBody2D):
	if body.name == "player 2":
		global.going_right = false
		global.going_left = true
		global.going_down = false
		global.transition_scene = true

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "left_path":
			get_tree().change_scene_to_file("res://WORLD.tscn")
			global.finish_changescenes()
