extends Node2D

func _ready():
	if SceneManager.going_down:
		$"player".position.x = SceneManager.player_exit_down_posx
		$"player".position.y = SceneManager.player_exit_down_posy
func _process(delta):
	change_scene()

func _on_secret_exit_point_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		SceneManager.going_down = false
		SceneManager.going_left = false
		SceneManager.going_right = false
		SceneManager.going_secret = true
		SceneManager.transition_scene = true
		
func change_scene():
	if SceneManager.transition_scene == true:
		if SceneManager.current_scene == "secret":
			get_tree().change_scene_to_file("res://SCENES/WORLD_REAL.tscn")
			SceneManager.finish_changescenes()
		elif SceneManager.current_scene == "secret":
			get_tree().change_scene_to_file("res://SCENES/down_path.tscn")
			SceneManager.finish_changescenes()


func _on_down_transition_point_body_entered(body: Node2D) -> void:
	if body.name == "player":
		SceneManager.going_down = true
		SceneManager.going_left = false
		SceneManager.going_right = false
		SceneManager.going_secret = false
		SceneManager.transition_scene = true
