extends Node2D

func _ready():
	if SceneManager.going_dungeon:
		$"player".position.x = SceneManager.player_exit_dungeon_posx
		$"player".position.y = SceneManager.player_exit_dungeon_posy
	elif SceneManager.going_overworld:
		$"player".position.x = SceneManager.player_exit_overworld_posx
		$"player".position.y = SceneManager.player_exit_overworld_posy
	
func _process(delta):
	change_scene()

func _on_down_exit_point_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		SceneManager.going_secret = false
		SceneManager.going_down = true
		SceneManager.going_dungeon = false
		SceneManager.going_overworld = false
		SceneManager.transition_scene = true

func change_scene():
	if SceneManager.transition_scene == true:
		if SceneManager.current_scene == "down_path":
			get_tree().change_scene_to_file("res://SCENES/secret.tscn")
			SceneManager.finish_changescenes()
		elif SceneManager.current_scene == "down_path":
			get_tree().change_scene_to_file("res://SCENES/dungeon.tscn")
			SceneManager.finish_changescenes()
		elif SceneManager.current_scene == "down_path":
			get_tree().change_scene_to_file("res://SCENES/overworld.tscn")
			SceneManager.finish_changescenes()


func _on_dungeon_transition_point_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		SceneManager.going_secret = false
		SceneManager.going_down = false
		SceneManager.going_dungeon = true
		SceneManager.going_overworld = false
		SceneManager.transition_scene = true


func _on_overworld_transition_point_body_entered(body: Node2D) -> void:
	if body.name == "player":
		SceneManager.going_secret = false
		SceneManager.going_down = false
		SceneManager.going_dungeon = false
		SceneManager.going_overworld = true
		SceneManager.going_building = false
		SceneManager.transition_scene = true
