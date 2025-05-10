extends Node2D

func _ready():
	if global.game_first_loadin == true:
		$"player 2".position.x = global.player_start_posx
		$"player 2".position.y = global.player_start_posy
	else:
		$"player 2".position.x = global.player_exit_leftpath_posx
		$"player 2".position.y = global.player_exit_leftpath_posy

func _process(delta):
	change_scene()

func _on_leftpath_transition_point_body_entered(body: PhysicsBody2D):
	if body.name == "player 2":
		global.transition_scene = true

'''
func _on_leftpath_transition_point_body_exited(body: PhysicsBody2D):
	if body.name == "player 2":
		global.transition_scene = false
		
'''
func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://left_path.tscn")
			global.game_first_loadin = false
			global.finish_changescenes()
