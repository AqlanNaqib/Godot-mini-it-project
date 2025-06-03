extends Node2D


func _process(delta):
	change_scene()


func _on_leftpath_exit_point_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		SceneManager.going_right = false
		SceneManager.going_left = true
		SceneManager.going_down = false
		SceneManager.going_secret = false
		SceneManager.transition_scene = true

func change_scene():
	if SceneManager.transition_scene == true:
		if SceneManager.current_scene == "left_path":
			get_tree().change_scene_to_file("res://SCENES/WORLD_REAL.tscn")
			SceneManager.finish_changescenes()
