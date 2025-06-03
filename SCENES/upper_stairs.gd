extends Node2D

func _process(delta):
	change_scene()

func _on_upper_stairs_exit_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		global.going_upper_stairs = true
		global.transition_scene = true
		
func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "upper_stairs":
			get_tree().change_scene_to_file("res://SCENES/House1.tscn")
			global.finish_changescenes()
