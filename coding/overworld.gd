extends Node2D

func _ready():
	if SceneManager.going_building:
		$"player".position.x = SceneManager.player_exit_building_posx
		$"player".position.y = SceneManager.player_exit_building_posy
		
func _process(delta):
	change_scene()

func _on_overworld_exit_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		SceneManager.going_overworld = true
		SceneManager.going_building = false
		SceneManager.transition_scene = true

func change_scene():
	if SceneManager.transition_scene == true:
		if SceneManager.current_scene == "overworld":
			get_tree().change_scene_to_file("res://SCENES/down_path.tscn")
			SceneManager.finish_changescenes()
		elif SceneManager.current_scene == "overworld":
			get_tree().change_scene_to_file("res://SCENES/building.tscn")
			SceneManager.finish_changescenes()


func _on_building_transition_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		SceneManager.going_overworld = false
		SceneManager.going_building = true
		SceneManager.transition_scene = true
