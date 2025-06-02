extends Node2D

func _ready():
	if global.going_dungeon:
		$"player".position.x = global.player_exit_dungeon_posx
		$"player".position.y = global.player_exit_dungeon_posy
	
func _process(delta):
	change_scene()

func _on_down_exit_point_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		global.going_down = true
		global.going_dungeon = false
		global.transition_scene = true

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "down_path":
			get_tree().change_scene_to_file("res://SCENES/secret.tscn")
			global.finish_changescenes()
		elif global.current_scene == "down_path":
			get_tree().change_scene_to_file("res://SCENES/dungeon.tscn")
			global.finish_changescenes()


func _on_dungeon_transition_point_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		global.going_down = false
		global.going_dungeon = true
		global.transition_scene = true
