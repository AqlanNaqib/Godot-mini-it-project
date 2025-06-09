extends Node2D

func _process(delta):
	change_scene()

func _on_sec_dungeon_exit_point_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		SceneManager.going_sec_dungeon = true
		SceneManager.going_dungeon = false
		SceneManager.transition_scene = true
	
func change_scene():
	if SceneManager.transition_scene == true:
		if SceneManager.current_scene == "sec_dungeon":
			get_tree().change_scene_to_file("res://SCENES/dungeon.tscn")
			SceneManager.finish_changescenes()
