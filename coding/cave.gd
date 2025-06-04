extends Node2D

func _ready():
	if SceneManager.going_sec_cave:
		$"player".position.x = SceneManager.player_exit_sec_cave_posx
		$"player".position.y = SceneManager.player_exit_sec_cave_posy

func _process(delta):
	change_scene()
	
func _on_cave_exit_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		SceneManager.going_cave = true
		SceneManager.going_sec_cave = false
		SceneManager.transition_scene = true

func change_scene():
	if SceneManager.transition_scene == true:
		if SceneManager.current_scene == "cave":
			get_tree().change_scene_to_file("res://SCENES/House2.tscn")
			SceneManager.finish_changescenes()
		elif SceneManager.current_scene == "cave":
			get_tree().change_scene_to_file("res://SCENES/sec_cave.tscn")


func _on_sec_cave_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		SceneManager.going_sec_cave = true
		SceneManager.going_cave = false
		SceneManager.transition_scene = true
