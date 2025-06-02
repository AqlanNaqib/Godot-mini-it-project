extends Node


var current_scene = "world"
var transition_scene = false

var going_left = false
var going_right = false 
var going_down = false
var going_secret = false
var going_dungeon = false
var going_overworld = false

var player_exit_leftpath_posx = -233
var player_exit_leftpath_posy = -59
var player_exit_rightpath_posx = 231
var player_exit_rightpath_posy = 72
var player_exit_secret_posx = 160
var player_exit_secret_posy = 131
var player_exit_down_posx = 17
var player_exit_down_posy = 121
var player_exit_dungeon_posx = 0
var player_exit_dungeon_posy = 0
var player_exit_overworld_posx = 0
var player_exit_overworld_posy = 0
var player_start_posx = 0
var player_start_posy = -1

var game_first_loadin = true

func finish_changescenes():
	if transition_scene:
		transition_scene = false
		if current_scene == "world" and going_left:
			current_scene = "left_path"
			get_tree().change_scene_to_file("res://SCENES/left_path.tscn")
		elif current_scene == "world" and going_right:
			current_scene = "right_path"
			get_tree().change_scene_to_file("res://SCENES/right_path.tscn")
		elif current_scene == "world" and going_secret:
			current_scene = "secret"
			get_tree().change_scene_to_file("res://SCENES/secret.tscn")
		elif current_scene == "secret" and going_down:
			current_scene = "down_path"
			get_tree().change_scene_to_file("res://SCENES/down_path.tscn")
		elif current_scene == "down_path" and going_down:
			current_scene = "secret"
			get_tree().change_scene_to_file("res://SCENES/secret.tscn")
		else:
			current_scene = "world"
			get_tree().change_scene_to_file("res://WORLD.tscn")
