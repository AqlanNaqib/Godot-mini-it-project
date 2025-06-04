extends Node2D

func _ready():
	if SceneManager.going_extension:
		$"player".position.x = SceneManager.player_exit_extension_posx
		$"player".position.y = SceneManager.player_exit_extension_posy

func _process(delta):
	change_scene()

func _on_building_exit_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		SceneManager.going_building = true
		SceneManager.going_overworld = false
		SceneManager.transition_scene = true

func change_scene():
	if SceneManager.transition_scene == true:
		if SceneManager.current_scene == "building":
			get_tree().change_scene_to_file("res://SCENES/overworld.tscn")
			SceneManager.finish_changescenes()
		elif SceneManager.current_scene == "building":
			get_tree().change_scene_to_file("res://SCENES/extension.tscn")
			SceneManager.finish_changescenes()


func _on_extension_transition_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		SceneManager.going_building = false
		SceneManager.going_overworld = false
		SceneManager.going_extension = true
		SceneManager.transition_scene = true
		
