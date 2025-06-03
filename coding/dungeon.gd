extends Node2D

func _ready():
	if global.going_sec_dungeon:
		$"player".position.x = global.player_exit_sec_dungeon_posx
		$"player".position.y = global.player_exit_sec_dungeon_posy

func _process(delta):
	change_scene()

func _on_dungeon_exit_point_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		global.going_down = false
		global.going_dungeon = true
		global.transition_scene = true

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "dungeon":
			get_tree().change_scene_to_file("res://SCENES/down_path.tscn")
			global.finish_changescenes()
		elif global.current_scene == "dungeon":
			get_tree().change_scene_to_file("res://SCENES/sec_dungeon.tscn")
			global.finish_changescenes()


func _on_sec_dungeon_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		global.going_dungeon = false
		global.going_down = false
		global.going_sec_dungeon = true
		global.transition_scene = true
		
