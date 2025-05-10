extends Node


var current_scene = "world"
var transition_scene = false

var player_exit_leftpath_posx = -233
var player_exit_leftpath_posy = -59
var player_start_posx = 0
var player_start_posy = -1

var game_first_loadin = true

func finish_changescenes():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "world":
			current_scene = "left_path"
		else:
			current_scene = "world"
