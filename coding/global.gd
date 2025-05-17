extends Node


var current_scene = "world"
var transition_scene = false

var going_left = false
var going_right = false 
var going_down = false

var player_exit_leftpath_posx = -233
var player_exit_leftpath_posy = -59
var player_exit_rightpath_posx = 231
var player_exit_rightpath_posy = 72
var player_exit_secret_posx = 160
var player_exit_secret_posy = 131
var player_start_posx = 0
var player_start_posy = -1

var game_first_loadin = true

func finish_changescenes():
	if transition_scene:
		transition_scene = false
		if current_scene == "world" and going_left:
			current_scene = "left_path"
			get_tree().change_scene_to_file("res://left_path.tscn")
		elif current_scene == "world" and going_right:
			current_scene = "right_path"
			get_tree().change_scene_to_file("res://right_path.tscn")
		elif current_scene == "world" and going_down:
			current_scene = "secret"
			get_tree().change_scene_to_file("res://secret.tscn")
		else:
			current_scene = "world"
			get_tree().change_scene_to_file("res://WORLD.tscn")
