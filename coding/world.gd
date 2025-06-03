extends Node2D


func _ready():
	var playerCharPath = GlobalData.playerCharPath
	var playerNode = load(playerCharPath).instantiate()
	add_child(playerNode)
	if global.game_first_loadin == true:
		$"player".position.x = global.player_start_posx
		$"player".position.y = global.player_start_posy
	else:
		if global.going_left:
			$"player".position.x = global.player_exit_leftpath_posx
			$"player".position.y = global.player_exit_leftpath_posy
		elif global.going_right:
			$"player".position.x = global.player_exit_rightpath_posx
			$"player".position.y = global.player_exit_rightpath_posy
		elif global.going_secret:
			$"player".position.x = global.player_exit_secret_posx
			$"player".position.y = global.player_exit_secret_posy
		elif global.going_house1:
			$"player".position.x = global.player_exit_house1_posx
			$"player".position.y = global.player_exit_house1_posy

func _process(delta):
	pass

func _on_leftpath_transition_point_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		global.going_left = true
		global.going_right = false
		global.transition_scene = true
		global.game_first_loadin = false
		global.finish_changescenes()
		
func _on_rightpath_transition_point_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		global.going_left = false
		global.going_right = true
		global.transition_scene = true
		global.game_first_loadin = false
		global.finish_changescenes()


func _on_secret_transition_point_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		global.going_left = false
		global.going_right = false
		global.going_down = false
		global.going_secret = true
		global.transition_scene = true
		global.game_first_loadin = false
		global.finish_changescenes()


func _on_house_transition_body_entered(body: PhysicsBody2D):
	if body.name == "player":
			global.going_house1 = true
			global.transition_scene = true
			global.game_first_loadin = false
			global.finish_changescenes()
