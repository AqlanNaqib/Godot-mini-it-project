extends Node2D

func _process(delta):
	change_scene()

func _on_house_exit_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		global.going_house1 = true
		global.transition_scene = true

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "house1":
			get_tree().change_scene_to_file("res://SCENES/WORLD_REAL.tscn")
			global.finish_changescenes()
