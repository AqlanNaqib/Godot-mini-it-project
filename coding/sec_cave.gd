extends Node2D

func _process(delta):
	change_scene()
	

func _on_sec_cave_exit_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		SceneManager.going_sec_cave = true
		SceneManager.going_cave = false
		SceneManager.transition_scene = true

func change_scene():
	if SceneManager.transition_scene == true:
		if SceneManager.current_scene == "sec_cave":
			get_tree().change_scene_to_file("res://SCENES/cave.tscn")
			SceneManager.finish_changescenes()
