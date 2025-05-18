extends Node2D

func _ready():
	if global.going_down:
		$"player 2".position.x = global.player_exit_down_posx
		$"player 2".position.y = global.player_exit_down_posy
func _process(delta):
	change_scene()

func _on_secret_exit_point_body_entered(body: PhysicsBody2D):
	if body.name == "player 2":
		global.going_down = false
		global.going_left = false
		global.going_right = false
		global.going_secret = true
		global.transition_scene = true
		
func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "secret":
			get_tree().change_scene_to_file("res://SCENES/WORLD_REAL.tscn")
			global.finish_changescenes()
		elif global.current_scene == "secret":
			get_tree().change_scene_to_file("res://SCENES/down_path.tscn")
			global.finish_changescenes()


func _on_down_transition_point_body_entered(body: Node2D) -> void:
	if body.name == "player 2":
		global.going_down = true
		global.going_left = false
		global.going_right = false
		global.going_secret = false
		global.transition_scene = true
