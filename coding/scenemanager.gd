extends Node


var current_scene = "world"
var transition_scene = false

var going_left = false
var going_right = false 
var going_down = false
var going_secret = false
var going_dungeon = false
var going_sec_dungeon = false
var going_overworld = false
var going_house1 = false
var going_house2 = false
var going_cave = false
var going_sec_cave = false
var going_upper_stairs = false

var player_exit_leftpath_posx = -233
var player_exit_leftpath_posy = -59
var player_exit_rightpath_posx = 231
var player_exit_rightpath_posy = 72
var player_exit_secret_posx = 160
var player_exit_secret_posy = 131
var player_exit_down_posx = 25
var player_exit_down_posy = 139
var player_exit_dungeon_posx = -225
var player_exit_dungeon_posy = 21
var player_exit_overworld_posx = 0
var player_exit_overworld_posy = 0
var player_exit_sec_dungeon_posx = -111
var player_exit_sec_dungeon_posy = 82
var player_exit_house1_posx = -128
var player_exit_house1_posy = 79
var player_exit_house2_posx = 188
var player_exit_house2_posy = -28
var player_exit_upper_stairs_posx = -121
var player_exit_upper_stairs_posy = -34
var player_exit_cave_posx = -127
var player_exit_cave_posy = -35
var player_exit_sec_cave_posx = 208
var player_exit_sec_cave_posy = 93
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
		elif current_scene == "right_path" and going_house2:
			current_scene = "house2"
			get_tree().change_scene_to_file("res://SCENES/House2.tscn")
		elif current_scene == "house2" and going_house2:
			current_scene = "right_path"
			get_tree().change_scene_to_file("res://SCENES/right_path.tscn")
		elif current_scene == "house2" and going_cave:
			current_scene = "cave"
			get_tree().change_scene_to_file("res://SCENES/cave.tscn")
		elif current_scene == "cave" and going_cave:
			current_scene = "house2"
			get_tree().change_scene_to_file("res://SCENES/House2.tscn")
		elif current_scene == "cave" and going_sec_cave:
			current_scene = "sec_cave"
			get_tree().change_scene_to_file("res://SCENES/sec_cave.tscn")
		elif current_scene == "sec_cave" and going_sec_cave:
			current_scene = "cave"
			get_tree().change_scene_to_file("res://SCENES/cave.tscn")
		elif current_scene == "world" and going_secret:
			current_scene = "secret"
			get_tree().change_scene_to_file("res://SCENES/secret.tscn")
		elif current_scene == "world" and going_house1:
			current_scene = "house1"
			get_tree().change_scene_to_file("res://SCENES/House1.tscn")
		elif current_scene == "house1" and going_upper_stairs:
			current_scene = "upper_stairs"
			get_tree().change_scene_to_file("res://SCENES/upper_stairs.tscn")
		elif current_scene == "secret" and going_down:
			current_scene = "down_path"
			get_tree().change_scene_to_file("res://SCENES/down_path.tscn")
		elif current_scene == "upper_stairs" and going_upper_stairs:
			current_scene = "house1"
			get_tree().change_scene_to_file("res://SCENES/House1.tscn")
		elif current_scene == "down_path" and going_down:
			current_scene = "secret"
			get_tree().change_scene_to_file("res://SCENES/secret.tscn")
		elif current_scene == "down_path" and going_dungeon:
			current_scene = "dungeon"
			get_tree().change_scene_to_file("res://SCENES/dungeon.tscn")
		elif current_scene == "dungeon" and going_dungeon:
			current_scene = "down_path"
		elif current_scene == "dungeon" and going_sec_dungeon:
			current_scene = "sec_dungeon"
			get_tree().change_scene_to_file("res://SCENES/sec_dungeon.tscn")
		elif current_scene == "sec_dungeon" and going_sec_dungeon:
			current_scene = "dungeon"
			get_tree().change_scene_to_file("res://SCENES/dungeon.tscn")
		else:
			current_scene = "world"
			get_tree().change_scene_to_file("res://WORLD.tscn")
