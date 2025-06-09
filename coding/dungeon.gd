extends Node2D

func _ready():
	if SceneManager.going_sec_dungeon:
		$"player".position.x = SceneManager.player_exit_sec_dungeon_posx
		$"player".position.y = SceneManager.player_exit_sec_dungeon_posy

func _process(delta):
	change_scene()

func _on_dungeon_exit_point_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		SceneManager.going_down = false
		SceneManager.going_dungeon = true
		SceneManager.transition_scene = true

func change_scene():
	if SceneManager.transition_scene == true:
		if SceneManager.current_scene == "dungeon":
			get_tree().change_scene_to_file("res://SCENES/down_path.tscn")
			SceneManager.finish_changescenes()
		elif SceneManager.current_scene == "dungeon":
			get_tree().change_scene_to_file("res://SCENES/sec_dungeon.tscn")
			SceneManager.finish_changescenes()


func _on_sec_dungeon_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		SceneManager.going_dungeon = false
		SceneManager.going_down = false
		SceneManager.going_sec_dungeon = true
		SceneManager.transition_scene = true
		
