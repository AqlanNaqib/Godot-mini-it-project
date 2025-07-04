extends Node2D

var choose_player := preload("res://character_selection.tscn")
func _ready():
	if SceneManager.game_first_loadin == true:
		$"player_with_spear".position.x = SceneManager.player_start_posx
		$"player_with_spear".position.y = SceneManager.player_start_posy
	else:
		if SceneManager.going_left:
			$"player_with_spear".position.x = SceneManager.player_exit_leftpath_posx
			$"player_with_spear".position.y = SceneManager.player_exit_leftpath_posy
		elif SceneManager.going_right:
			$"player_with_spear".position.x = SceneManager.player_exit_rightpath_posx
			$"player_with_spear".position.y = SceneManager.player_exit_rightpath_posy
		elif SceneManager.going_secret:
			$"player_with_spear".position.x = SceneManager.player_exit_secret_posx
			$"player_with_spear".position.y = SceneManager.player_exit_secret_posy
		elif SceneManager.going_house1:
			$"player_with_spear".position.x = SceneManager.player_exit_house1_posx
			$"player_with_spear".position.y = SceneManager.player_exit_house1_posy
	var Choose_player := choose_player.instantiate()
	get_tree().current_scene.add_child(Choose_player)

func _process(delta):
	pass

func _on_leftpath_transition_point_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		SceneManager.going_left = true
		SceneManager.going_right = false
		SceneManager.transition_scene = true
		SceneManager.game_first_loadin = false
		SceneManager.finish_changescenes()
		
func _on_rightpath_transition_point_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		SceneManager.going_left = false
		SceneManager.going_right = true
		SceneManager.transition_scene = true
		SceneManager.game_first_loadin = false
		SceneManager.finish_changescenes()


func _on_secret_transition_point_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		SceneManager.going_left = false
		SceneManager.going_right = false
		SceneManager.going_down = false
		SceneManager.going_secret = true
		SceneManager.transition_scene = true
		SceneManager.game_first_loadin = false
		SceneManager.finish_changescenes()


func _on_house_transition_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		SceneManager.going_left = false
		SceneManager.going_right = false
		SceneManager.going_down = false
		SceneManager.going_secret = false
		SceneManager.going_house1 = true
		SceneManager.transition_scene = true
		SceneManager.game_first_loadin = false
		SceneManager.finish_changescenes()
