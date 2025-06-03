extends Node2D

func _ready():
	if SceneManager.going_upper_stairs:
		$"player".position.x = SceneManager.player_exit_upper_stairs_posx
		$"player".position.y = SceneManager.player_exit_upper_stairs_posy
		
func _process(delta):
	change_scene()

func _on_house_exit_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		SceneManager.going_house1 = true
		SceneManager.going_upper_stairs = false
		SceneManager.transition_scene = true

func change_scene():
	if SceneManager.transition_scene == true:
		if SceneManager.current_scene == "house1":
			get_tree().change_scene_to_file("res://SCENES/WORLD_REAL.tscn")
			SceneManager.finish_changescenes()
		elif SceneManager.current_scene == "upper_stairs":
			get_tree().change_scene_to_file("res://SCENES/upper_stairs.tscn")
			SceneManager.finish_changescenes()


func _on_upper_stairs_transition_body_entered(body: Node2D) -> void:
	if body.name == "player":
		SceneManager. going_house1 = false
		SceneManager.going_upper_stairs = true
		SceneManager.transition_scene = true
