extends Node2D

func _ready():
	if SceneManager.going_house2:
		$"player".position.x = SceneManager.player_exit_house2_posx
		$"player".position.y = SceneManager.player_exit_house2_posy
		
func _process(delta):
	change_scene()

func _on_rightpath_exit_point_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		SceneManager.going_right = true
		SceneManager.going_left = false
		SceneManager.going_down = false
		SceneManager.going_secret = false
		SceneManager.going_house2 = false
		SceneManager.transition_scene = true
		
func change_scene():
	if SceneManager.transition_scene == true:
		if SceneManager.current_scene == "right_path":
			get_tree().change_scene_to_file("res://SCENES/WORLD_REAL.tscn")
			SceneManager.finish_changescenes()
		elif SceneManager.current_scene == "right_path":
			get_tree().change_scene_to_file("res://SCENES/House2.tscn")
			SceneManager.finish_changescenes()


func _on_house_2_transition_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		SceneManager.going_house2 = true
		SceneManager.transition_scene = true
