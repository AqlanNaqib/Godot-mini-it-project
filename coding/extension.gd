extends Node2D

		
func _process(delta):
	change_scene()
	
func _on_extension_exit_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		SceneManager.going_extension = true
		SceneManager.going_building = false
		SceneManager.transition_scene = true
	
func change_scene():
	if SceneManager.transition_scene == true:
		if SceneManager.current_scene == "extension":
			get_tree().change_scene_to_file("res://SCENES/building.tscn")
			SceneManager.finish_changescenes()
