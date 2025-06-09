extends Node2D

func _ready():
	if SceneManager.going_cave:
		$"player".position.x = SceneManager.player_exit_cave_posx
		$"player".position.y = SceneManager.player_exit_cave_posy
		
func _process(delta):
	change_scene()


func _on_cave_transition_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		SceneManager.going_house2 = false
		SceneManager.going_right = false
		SceneManager.going_cave = true
		SceneManager.transition_scene = true


func _on_house_2_exit_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		SceneManager.going_right = false
		SceneManager.going_house2 = true
		SceneManager.transition_scene = true

func change_scene():
	if SceneManager.transition_scene == true:
		if SceneManager.current_scene == "house2":
			SceneManager.finish_changescenes()
		elif SceneManager.current_scene == "house2":
			get_tree().change_scene_to_file("res://SCENES/cave.tscn")
			SceneManager.finish_changescenes()
