extends Node2D


func _ready():
	if global.game_first_loadin == true:
		$"player 2".position.x = global.player_start_posx
		$"player 2".position.y = global.player_start_posy
	else:
		if global.going_left:
			$"player 2".position.x = global.player_exit_leftpath_posx
			$"player 2".position.y = global.player_exit_leftpath_posy
		elif global.going_right:
			$"player 2".position.x = global.player_exit_rightpath_posx
			$"player 2".position.y = global.player_exit_rightpath_posy
		elif global.going_down:
			$"player 2".position.x = global.player_exit_secret_posx
			$"player 2".position.y = global.player_exit_secret_posy

func _process(delta):
	pass

func _on_leftpath_transition_point_body_entered(body: PhysicsBody2D):
	if body.name == "player 2":
		global.going_left = true
		global.going_right = false
		global.transition_scene = true
		global.game_first_loadin = false
		global.finish_changescenes()
		
func _on_rightpath_transition_point_body_entered(body: PhysicsBody2D):
	if body.name == "player 2":
		global.going_left = false
		global.going_right = true
		global.transition_scene = true
		global.game_first_loadin = false
		global.finish_changescenes()


func _on_secret_transition_point_body_entered(body: PhysicsBody2D):
	if body.name == "player 2":
		global.going_left = false
		global.going_right = false
		global.going_down = true
		global.transition_scene = true
		global.game_first_loadin = false
		global.finish_changescenes()
