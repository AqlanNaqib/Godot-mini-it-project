extends Node2D

func _ready():
	if global.going_upper_stairs:
		$"player".position.x = global.player_exit_upper_stairs_posx
		$"player".position.y = global.player_exit_upper_stairs_posy
		
func _process(delta):
	change_scene()

func _on_house_exit_body_entered(body: PhysicsBody2D):
	if body.name == "player":
		global.going_house1 = true
		global.going_upper_stairs = false
		global.transition_scene = true

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "house1":
			get_tree().change_scene_to_file("res://SCENES/WORLD_REAL.tscn")
			global.finish_changescenes()
		elif global.current_scene == "upper_stairs":
			get_tree().change_scene_to_file("res://SCENES/upper_stairs.tscn")
			global.finish_changescenes()


func _on_upper_stairs_transition_body_entered(body: Node2D) -> void:
	if body.name == "player":
		global. going_house1 = false
		global.going_upper_stairs = true
		global.transition_scene = true
